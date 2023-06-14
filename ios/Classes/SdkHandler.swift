import MIRACLTrust
import Flutter

public class SdkHandler: NSObject, MiraclSdk {
    func getAuthenticationIdentity(userId: String, completion: @escaping (Result<MIdentity, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId);
        
        if let sdkUser {
            let authId = sdkUser.getAuthenticationIdentity();
            if let authId {
                completion(Result.success(MIdentity(dtas: authId.dtas, id: authId.uuid.uuidString, hashedMpinId: authId.hashedMpinId, mpinId: FlutterStandardTypedData(bytes: authId.mpinId), pinLength: Int64(authId.pinLength), token: FlutterStandardTypedData(bytes: authId.token))))
            }
        }
    }
    
    func initSdk(configuration: MConfiguration, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let conf = try Configuration.Builder( projectId: configuration.projectId,
                                              clientId: configuration.clientId,
                                              redirectURI: configuration.redirectUri).build()
            completion(Result.success(try MIRACLTrust.configure(with: conf)))
        }catch {
            completion(Result.failure(error))
        }

    }
    
    
    func signingRegister(userId: String, pin: String, completion: @escaping (Result<MUser, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        
        if let sdkUser {
            MIRACLTrust.getInstance().signingRegister(user: sdkUser) { processPin in
                processPin(pin)
            } didRequestSigningPinHandler: { processPin in
                processPin(pin)
            } completionHandler: { user, error in
                if let error = error {
                    completion(Result.failure(error));
                } else if let user = user {
                    completion(Result.success(self.userToMUser(user: user)));
                }
            }

        }
    }
    
    func sign(userId: String, pin: String, message: FlutterStandardTypedData, date: Int64, completion: @escaping (Result<MSignature, Error>) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        
        if let sdkUser {
            MIRACLTrust.getInstance().sign(message: message.data, timestamp: Date(timeIntervalSince1970: TimeInterval(date)), user: sdkUser) { processPin in
                processPin(pin)
            } completionHandler: { signature, error in
                if let error = error {
                    completion(Result.failure(error));
                } else if let signature = signature {
                    
                    completion(Result.success(MSignature(u: signature.U, v: signature.V, dtas: signature.dtas, mpinId: signature.mpinId, hash: signature.signatureHash, publicKey: signature.publicKey)))
                }
            }

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
                completion(Result.success(result))
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
    
    func getUsers() throws -> [MUser] {
       return MIRACLTrust.getInstance().users.map { user in
            userToMUser(user: user)
        }
    }
    
    func register(userId: String, activationToken: String, pin: String, pushToken: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        return MIRACLTrust.getInstance().register(for: userId, activationToken: activationToken) {  pinProcessor in
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
                                                nowTime: Int64(quickCode.nowTime.timeIntervalSince1970),
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
        return MUser(authenticationIdentityId:  user.authenticationIdentityId.uuidString, projectId: user.projectId, revoked: user.revoked, signingIdentityId: user.signingIdentityId?.uuidString ?? "", userId: user.userId)
    }

    
}
