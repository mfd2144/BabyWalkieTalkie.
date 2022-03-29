



import Foundation
public protocol TokenServiceProtocol:AnyObject{
    func fetchRtcToken(channel:String ,completion: @escaping (Results<String>)->Void)
    func fetchRtmToken(userName:String ,completion: @escaping (Results<String>)->Void)
   
}

public final class TokenGeneratorService:TokenServiceProtocol{
    
    init() { }
    public func fetchRtcToken( channel: String, completion: @escaping (Results<String>) -> Void) {
        let a: UInt = 0
        let urlString = "https://listenmybaby.herokuapp.com/access_token?channel=\(channel)&uid=\(a)"
        guard let url = URL(string: urlString) else {return completion(.failure(TokenErrors.wrongUrl))}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if let _ = error{
                completion(.failure(TokenErrors.fetchTokenError))
            }else {
                guard let data = data else {return completion(.failure(TokenErrors.emptyTokenError))}
                let decoder = Decoders.plainDecoder
                do {
                    let tokenResponse = try decoder.decode(TokenGeneratorResponse.self, from: data)
                    guard let result = tokenResponse.result else { return completion(.failure(TokenErrors.fetchTokenError))}
                    completion(.success(result))
                } catch  {
                    completion(.failure(TokenErrors.tokenDecodeError))
                }
               
            }
            
        }
        task.resume()
    }
    
    public func fetchRtmToken(userName: String, completion: @escaping (Results<String>) -> Void) {
        let urlString = "https://agora-rtm-tokengenerator.herokuapp.com/rtmToken?account=\(userName)"
                guard let url = URL(string: urlString) else {return completion(.failure(TokenErrors.wrongUrl))}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if let _ = error{
                completion(.failure(TokenErrors.fetchTokenError))
            }else {
                guard let data = data else {return completion(.failure(TokenErrors.emptyTokenError))}
                let decoder = Decoders.plainDecoder
                do {
                    let tokenResponse = try decoder.decode(RtmTokenGeneratorResponse.self, from: data)
                    guard let result = tokenResponse.result else { return completion(.failure(TokenErrors.fetchTokenError))}
                    completion(.success(result))
                } catch  {
                    completion(.failure(TokenErrors.tokenDecodeError))
                }
               
            }
            
        }
        task.resume()
        
        
    }
}

//new token generator = "https://agora-rtm-tokengenerator.herokuapp.com/rtcToken?channelName=dds"
//let old url:String = "https://listenmybaby.herokuapp.com/access_token?channel=test&uid=1234"

enum TokenErrors:Error {
    case wrongUrl
    case emptyTokenError
    case fetchTokenError
    case tokenDecodeError
    var description:String?{
        switch  self {
        case .wrongUrl:
         return  " url failure"
        case.fetchTokenError:
            return "fetch token error"
        case.emptyTokenError:
            return "Empty token.Program won't work as you wished"
        case.tokenDecodeError:
            return "Decode error"
        }
    }
    
}


