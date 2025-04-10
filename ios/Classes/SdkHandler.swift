import MIRACLTrust
import Flutter

public class SdkHandler: NSObject, MiraclSdk {
    func getAuthenticationIdentity(userId: String, completion: @escaping (Result<MUser, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId);
        if let sdkUser {
            completion(Result.success(userToMUser(user: sdkUser)));
        }
    }
    
    func initSdk(configuration: MConfiguration, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let conf = try Configuration.Builder(projectId: configuration.projectId).build()
            completion(Result.success(try MIRACLTrust.configure(with: conf)))
        }catch {
            completion(Result.failure(error))
        }

    }
    
    
    func signingRegister(userId: String, pin: String, completion: @escaping (Result<MUser, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        
        if let sdkUser {
            completion(Result.success(userToMUser(user: sdkUser)));
        }
    }
    
    func sign(userId: String, pin: String, message: FlutterStandardTypedData, completion: @escaping (Result<MSigningResult, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)

        if let sdkUser {
            MIRACLTrust.getInstance().sign(
                message: message.data ,
                user: sdkUser,
                didRequestSigningPinHandler: { pinProcessor in
                    pinProcessor(pin)
                }, completionHandler: { signingResult, error in
                    if let error = error {
                        completion(Result.failure(error));
                    } else if let signingResult {
                        completion(Result.success(
                            MSigningResult(
                                signature: MSignature(
                                    u: signingResult.signature.U, 
                                    v: signingResult.signature.V, 
                                    dtas: signingResult.signature.dtas, 
                                    mpinId: signingResult.signature.mpinId, 
                                    hash: signingResult.signature.signatureHash, 
                                    publicKey: signingResult.signature.publicKey
                                ),
                                //TODO: Rado - This needs to be set correctly?
                                timestamp: Int64((signingResult.timestamp.timeIntervalSince1970 * 1000.0).rounded())
                            )
                        ))
                    }
                }
            )
        }
    }
    
    func authenticateWithQrCode(userId: String, pin: String, qrCode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        
        if let sdkUser {
            MIRACLTrust.getInstance().authenticateWithQRCode(user: sdkUser, qrCode: qrCode) {  pinProcessor in
                pinProcessor(pin)
            } completionHandler: { result, error in
                if let error = error {
                    completion(Result.failure(error));
                } else {
                    completion(Result.success(result))
                }
            }
        }
    }
    

    func sendVerificationEmail(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        MIRACLTrust.getInstance().sendVerificationEmail(userId: userId) { (result, error) in
            if let error = error {
                completion(Result.failure(error));
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func getActivationToken(uri: String, completion: @escaping (Result<MActivationTokenResponse, Error>) -> Void) {
        MIRACLTrust.getInstance().getActivationToken(verificationURL: URL(string: uri)!) { response, error in
            if let error = error {
                completion(Result.failure(error));
            } else if let response = response {
                let mActTokenResponse = MActivationTokenResponse(projectId: response.projectId , userId: response.userId, activationToken: response.activationToken)
                completion(Result.success(mActTokenResponse))
            }
        }
    }
    
    func getUsers(completion: @escaping (Result<[MUser], Error>) -> Void) {
        let users = MIRACLTrust.getInstance().users.map { user in
            userToMUser(user: user)
        }

        completion(Result.success(users))
    }
    
    func register(userId: String, activationToken: String, pin: String, pushToken: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        return MIRACLTrust.getInstance().register(for: userId, activationToken: activationToken, pushNotificationsToken: pushToken) {  pinProcessor in
            pinProcessor(pin)
        } completionHandler: { user, error in
            if let error = error {
                completion(Result.failure(error));
            } else if let user = user {
                completion(Result.success(self.userToMUser(user: user)))
            }
        }

    }
    
    func authenticate(user: MUser, pin: String, completion: @escaping (Result<String, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
        if let sdkUser {
            MIRACLTrust.getInstance().authenticate(user: sdkUser) { pinProcessor in
                pinProcessor(pin)
            } completionHandler: { result, error in
                if let error = error {
                    completion(Result.failure(error));
                } else if let result = result {
                    completion(Result.success(result))
                }
            }
        }
      
    }
    
    func getAuthenticationSessionDetailsFromQRCode(qrCode: String, completion: @escaping (Result<MAuthenticationSessionDetails, Error>) -> Void) {
        MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromQRCode(qrCode: qrCode) { authSession, error in
            if let error = error {
                completion(Result.failure(error));
            } else if let authSession = authSession {
                let mauthSession = MAuthenticationSessionDetails(userId: authSession.userId)
                completion(Result.success(mauthSession))
            }
        }
    }
    
    
    func generateQuickCode(userId: String, pin: String, completion: @escaping (Result<MQuickCode, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        if let sdkUser {
            MIRACLTrust.getInstance().generateQuickCode(user: sdkUser) { ProcessPinHandler in
                ProcessPinHandler(pin)
            } completionHandler: { quickCode, error in
                if let error = error {
                    completion(Result.failure(error));
                } else if let quickCode = quickCode {
                    let mquickCode = MQuickCode(code: quickCode.code,
                                                expiryTime: Int64(quickCode.expireTime.timeIntervalSince1970),
                                                ttlSeconds: Int64(quickCode.ttlSeconds))
                    completion(Result.success(mquickCode))
                }
            }
        }

    }
    
    func delete(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        if let sdkUser {
            do {
               try MIRACLTrust.getInstance().delete(user: sdkUser)
                completion(Result.success(()));
            } catch {
                completion(Result.failure(error))
            }
            
        }
    }
    

    func authenticateWithNotificationPayload(payload: [String : String], pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        MIRACLTrust.getInstance().authenticateWithPushNotificationPayload(payload: payload) { processPin in
            processPin(pin);
        } completionHandler: { isSuccess, error in
            if(isSuccess) {
                completion(Result.success(()));
            } else {
                if let error {
                    completion(Result.failure(error))
                }
            }
        }

    }
    
    
    
    func userToMUser(user:User) -> MUser {
        return MUser( projectId: user.projectId, revoked: user.revoked, userId: user.userId, hashedMpinId: user.hashedMpinId);
    }
}
