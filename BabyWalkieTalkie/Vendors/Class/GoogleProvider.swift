//
//  GoogleSignProvider.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 10.08.2021.
//

import GoogleSignIn
import Firebase
import UIKit


protocol GoogleProviderDelegate:AnyObject{
    func googleSignInDidFail(_ errorString:String)
    func googleSignInAccomplish()
}

final class GoogleProvider:NSObject{
    weak var delegate: GoogleProviderDelegate?
    var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [unowned self] user, error in

          if let error = error {
              Animator.sharedInstance.hideAnimation()
              let errorDescription = "\(NSLocalizedString(NSLocalizedString("googleSignError", comment: ""), comment: "")) : \(error.localizedDescription)"
              delegate?.googleSignInDidFail(errorDescription)
              return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            appContainer.authService.loginWithGoogle(credential) { [unowned self]result in
                Animator.sharedInstance.hideAnimation()
                switch result{
                case.failure(let error):
                    delegate?.googleSignInDidFail(error.description)
                case.success:
                    delegate?.googleSignInAccomplish()
                }
            }

        }
    }
}

