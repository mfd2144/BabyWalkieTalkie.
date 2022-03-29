//
//  AppleSignIn.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 13.03.2022.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth


protocol AppleSignInDelegate:AnyObject{
    func appleSignInAccomplish()
    func appleSignInError(error: String)
}

enum AppleSingInError:Error{
    case invalidState
    case fetchIDTokenFail
    case serializeError(String)
    case userInformationError
    
    var errorDescription:String{
        switch self {
        case .invalidState:
            return "Invalid state: A login callback was received, but no login request was sent."
        case .fetchIDTokenFail:
            return "Unable to fetch identity token"
        case .serializeError(let string):
            return   "Unable to serialize token string from data: \(string)"
        case .userInformationError:
            return "Please try another way to sign in"
        }
    }
}

final class AppleSignIn:NSObject{
    fileprivate var currentNonce: String?
    weak var delegate:AppleSignInDelegate?
    override init() {
        super.init()
        perfomSingIn()
    }
    
    private func perfomSingIn() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func createAppleIDRequest()->ASAuthorizationAppleIDRequest{
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "\(NSLocalizedString("nonceError", comment: "")) \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        
        return hashString
    }
}

extension AppleSignIn:ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        appContainer.router.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Animator.sharedInstance.showAnimation()
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            var name:String?
            var mail:String?
            if let givenName = appleIDCredential.fullName?.givenName{
                name = givenName
            }
            if let midName = appleIDCredential.fullName?.middleName{
                if let _name = name{
                    name = "\(_name) \(midName)"
                }else{
                    name = midName
                }
            }
            if let familyName = appleIDCredential.fullName?.familyName{
                if let _name = name{
                    name = "\(_name) \(familyName)"
                }else{
                    name = familyName
                }
            }
            if let email = appleIDCredential.email {
                mail = email
            }
 
            guard let nonce = currentNonce else {
                delegate?.appleSignInError(error: AppleSingInError.invalidState.errorDescription)
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                delegate?.appleSignInError(error: AppleSingInError.fetchIDTokenFail.errorDescription)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                delegate?.appleSignInError(error: AppleSingInError.serializeError(appleIDToken.debugDescription).errorDescription)
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            appContainer.authService.loginWithApple(credential,name: name,mail: mail) { [unowned self]result in
               
                switch result{
                case.failure(let error):
                    delegate?.appleSignInError(error: error.description)
                case.success:
                    delegate?.appleSignInAccomplish()
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Animator.sharedInstance.hideAnimation()
        delegate?.appleSignInError(error: error.localizedDescription)
    }
    
    
    
}
