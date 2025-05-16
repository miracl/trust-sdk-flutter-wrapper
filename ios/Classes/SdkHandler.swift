import MIRACLTrust
import Flutter

extension Error {
    var errorDebugDescription: String {
        return String(describing: self).components(separatedBy: "(").first ?? String(describing: self)
    }
}

public class SdkHandler: NSObject, MiraclSdk {

  func initSdk(
    configuration: MConfiguration, 
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    do {
        let conf = try Configuration
          .Builder(projectId: configuration.projectId)
          .applicationInfo(applicationInfo: configuration.applicationInfo)
          .build()
        completion(Result.success(try MIRACLTrust.configure(with: conf)))
    } catch {
        completion(Result.failure(createPigeonError(error: error)))
    }
  }

  func setProjectId(
    projectId: String, 
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    do {
        completion(
          Result.success(
              try MIRACLTrust.getInstance()
                  .setProjectId(projectId: projectId)
          )
        )
    } catch {
        completion(Result.failure(error))
    }
  }

  func sendVerificationEmail(
      userId: String, 
     completion: @escaping (Result<MEmailVerificationResponse, Error>) -> Void
  ) {
    MIRACLTrust.getInstance().sendVerificationEmail(userId: userId) { response, error in
        if let error {
            var details = [String: Any]()
            if case let VerificationError.verificaitonFail(verificationError) 
                            = error, let verificationError { 
                details["error"] = verificationError.errorDebugDescription       
            }

            if case let VerificationError.requestBackoff(backoff) = error { 
                details["backoff"] = backoff      
            }

            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
        } else if let response {
            let mEmailVerificationResponse = MEmailVerificationResponse(
              backoff: Int64(response.backoff),
              emailVerificationMethod: MEmailVerificationMethod(rawValue: response.method.rawValue) ?? .link
            )
            completion(Result.success(mEmailVerificationResponse))
        }
    }
  }

  func getActivationTokenByURI(
    uri: String, 
    completion: @escaping (Result<MActivationTokenResponse, Error>) -> Void
  ) {
     MIRACLTrust
        .getInstance()
        .getActivationToken(
            verificationURL: URL(string: uri)!,
            completionHandler: { activationTokenResponse, error in
                if let error {
                    var details = [String: Any]()
                    if let activationTokenError = error as? ActivationTokenError {
                        if case let ActivationTokenError.unsuccessfulVerification(activationTokenErrorResponse: response) 
                            = error, let response {
                            let mActivationTokenErrorResponse = MActivationTokenErrorResponse(
                                projectId: response.projectId,
                                accessId: response.accessId,
                                userId: response.userId
                            )

                            details["activationTokenErrorResponse"] = mActivationTokenErrorResponse
                        }
                    }

                    if case let ActivationTokenError.getActivationTokenFail(activationTokenError) = error, let activationTokenError { 
                        details["error"] = activationTokenError.errorDebugDescription       
                    }

                    let pigeonError = self.createPigeonError(error: error, details: details)
                    completion(Result.failure(pigeonError));
                    return
                }

                if let activationTokenResponse {
                    let mActTokenResponse = MActivationTokenResponse(
                        projectId: activationTokenResponse.projectId , 
                        userId: activationTokenResponse.userId, 
                        activationToken: activationTokenResponse.activationToken
                    )
                    completion(Result.success(mActTokenResponse))
                } 
            }
        )
  }

  func getActivationTokenByUserIdAndCode(
    userId: String, 
    code: String, 
    completion: @escaping (Result<MActivationTokenResponse, Error>) -> Void
  ) {
        MIRACLTrust
        .getInstance()
        .getActivationToken(
            userId: userId,
            code: code,
            completionHandler: { activationTokenResponse, error in
                if let error {
                    var details = [String: Any]()
                    if let activationTokenError = error as? ActivationTokenError {
                        if case let ActivationTokenError.unsuccessfulVerification(activationTokenErrorResponse: response) 
                            = error, let response {
                            let mActivationTokenErrorResponse = MActivationTokenErrorResponse(
                                projectId: response.projectId,
                                accessId: response.accessId,
                                userId: response.userId
                            )

                            details["activationTokenErrorResponse"] = mActivationTokenErrorResponse
                        }
                    }

                    if case let ActivationTokenError.getActivationTokenFail(activationTokenError) = error, let activationTokenError { 
                        details["error"] = activationTokenError.errorDebugDescription       
                    }

                    let pigeonError = self.createPigeonError(error: error, details: details)
                    completion(Result.failure(pigeonError));
                    return
                }

                if let activationTokenResponse {
                    let mActTokenResponse = MActivationTokenResponse(
                        projectId: activationTokenResponse.projectId , 
                        userId: activationTokenResponse.userId, 
                        activationToken: activationTokenResponse.activationToken
                    )
                    completion(Result.success(mActTokenResponse))
                } 
            }
        )
  }

  func getUsers(
    completion: @escaping (Result<[MUser], Error>) -> Void
  ) {
    let users = MIRACLTrust.getInstance().users.map { user in
      userToMUser(user: user)
    }

    completion(Result.success(users))
  }

  func delete(
    user: MUser, 
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
    if let sdkUser {
        do {
            try MIRACLTrust.getInstance().delete(user: sdkUser)
            completion(Result.success(()));
        } catch {
          let pigeonError = self.createPigeonError(error: error)
          completion(Result.failure(pigeonError))
        }
    }
  }

  func register(
    userId: String,
    activationToken: String, 
    pin: String, 
    pushToken: String?, 
    completion: @escaping (Result<MUser, Error>) -> Void
  ) {
      MIRACLTrust.getInstance().register(
        for: userId, 
        activationToken: activationToken, 
        pushNotificationsToken: pushToken
      ) {  pinProcessor in
          pinProcessor(pin)
      } completionHandler: { user, error in
          if let error {
            var details = [String: Any]()

            if case let RegistrationError.registrationFail(registrationError) = error, let registrationError { 
              details["error"] = registrationError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
          } else if let user{
              completion(Result.success(self.userToMUser(user: user)))
          }
      }
  }
  
  func generateQuickCode(
    user: MUser, 
    pin: String, 
    completion: @escaping (Result<MQuickCode, Error>) -> Void
  ) {
      let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
      if let sdkUser {
          MIRACLTrust.getInstance().generateQuickCode(user: sdkUser) { processPinHandler in
              processPinHandler(pin)
          } completionHandler: { quickCode, error in
                if let error = error {
                  var details = [String: Any]()

                  if case let QuickCodeError.generationFail(quikcCodeError) = error, let quikcCodeError { 
                    details["error"] = quikcCodeError.errorDebugDescription       
                  }
                  
                  let pigeonError = self.createPigeonError(error: error, details: details)
                  completion(Result.failure(pigeonError));
              } else if let quickCode = quickCode {
                  let mquickCode = MQuickCode(
                    code: quickCode.code,
                    expiryTime: Int64(quickCode.expireTime.timeIntervalSince1970),
                    ttlSeconds: Int64(quickCode.ttlSeconds)
                  )
                  completion(Result.success(mquickCode))
              }
          }
      }
  }

  func authenticate(
    user: MUser, 
    pin: String, 
    completion: @escaping (Result<String, Error>) -> Void
  ) {
      let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
      if let sdkUser {
          MIRACLTrust.getInstance().authenticate(user: sdkUser) { pinProcessor in
              pinProcessor(pin)
          } completionHandler: { result, error in
              if let error = error {
                  var details = [String: Any]()

                  if case let AuthenticationError.authenticationFail(authenticationError) = error, let authenticationError { 
                    details["error"] = authenticationError.errorDebugDescription       
                  }
                  
                  let pigeonError = self.createPigeonError(error: error, details: details)
                  completion(Result.failure(pigeonError));
              } else if let result = result {
                  completion(Result.success(result))
              }
          }
      }
  }

  func authenticateWithQrCode(
    user: MUser, 
    qrCode: String, 
    pin: String,
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
     let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
     if let sdkUser {
         MIRACLTrust.getInstance().authenticateWithQRCode(user: sdkUser, qrCode: qrCode) {  pinProcessor in
             pinProcessor(pin)
         } completionHandler: { result, error in
             if let error = error {
                  var details = [String: Any]()

                  if case let AuthenticationError.authenticationFail(authenticationError) = error, let authenticationError { 
                    details["error"] = authenticationError.errorDebugDescription       
                  }
                  
                  let pigeonError = self.createPigeonError(error: error, details: details)
                  completion(Result.failure(pigeonError));
             } else {
                completion(Result.success(result))
             }
        }
     }
  }

  func authenticateWithLink(
    user: MUser, 
    link: String,
    pin: String,  
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
     let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)
        
     if let sdkUser {
         MIRACLTrust.getInstance().authenticateWithUniversalLinkURL(
            user: sdkUser, 
            universalLinkURL: URL(string:link)!
         ) { pinProcessor in
             pinProcessor(pin)
         } completionHandler: { result, error in
             if let error = error {
                  var details = [String: Any]()

                  if case let AuthenticationError.authenticationFail(authenticationError) = error, let authenticationError { 
                    details["error"] = authenticationError.errorDebugDescription       
                  }
                  
                  let pigeonError = self.createPigeonError(error: error, details: details)
                  completion(Result.failure(pigeonError));                 
             } else {
                completion(Result.success(result))
             }
         }
     }
  }

  func authenticateWithNotificationPayload(
    payload: [String: String], 
    pin: String, 
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
     MIRACLTrust.getInstance().authenticateWithPushNotificationPayload(payload: payload) { processPin in
        processPin(pin);
     } completionHandler: { isSuccess, error in
        if(isSuccess) {
            completion(Result.success((true)));
        } else if let error{
            var details = [String: Any]()

            if case let AuthenticationError.authenticationFail(authenticationError) = error, let authenticationError { 
              details["error"] = authenticationError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
        }
     }
  }

  func getAuthenticationSessionDetailsFromQRCode(
    qrCode: String, 
    completion: @escaping (Result<MAuthenticationSessionDetails, Error>) -> Void
  ) {
      MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromQRCode(qrCode: qrCode) { authSession, error in
          if let error = error {
            var details = [String: Any]()

            if case let AuthenticationSessionError.getAuthenticationSessionDetailsFail(authenticationSessionError) = error, let authenticationSessionError { 
              details["error"] = authenticationSessionError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
          } else if let authSession {
               let mauthSession = MAuthenticationSessionDetails(
                   userId: authSession.userId,
                   projectName: authSession.projectName,
                   projectLogoURL: authSession.projectLogoURL,
                   projectId: authSession.projectId,
                   pinLength: Int64(authSession.pinLength),
                   verificationMethod: MVerificationMethod(rawValue: authSession.verificationMethod.rawValue) ?? .standardEmail ,
                   verificationURL: authSession.verificationURL,
                   verificationCustomText: authSession.verificationCustomText,
                   identityTypeLabel: authSession.identityTypeLabel,
                   quickCodeEnabled: authSession.quickCodeEnabled,
                   limitQuickCodeRegistration: authSession.limitQuickCodeRegistration,
                   identityType: MIdentityType(rawValue:authSession.identityType.rawValue) ?? .email,
                   accessId: authSession.accessId
               )
               completion(Result.success(mauthSession))
          }
      }
  }

  func getAuthenticationSessionDetailsFromLink(
    link: String, 
    completion: @escaping (Result<MAuthenticationSessionDetails, Error>) -> Void
  ) {
      MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromUniversalLinkURL(
        universalLinkURL: URL(string: link)!
      ) { authSession, error in
        if let error = error {
            var details = [String: Any]()

            if case let AuthenticationSessionError.getAuthenticationSessionDetailsFail(authenticationSessionError) = error, let authenticationSessionError { 
              details["error"] = authenticationSessionError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
        } else if let authSession {
              let mauthSession = MAuthenticationSessionDetails(
                  userId: authSession.userId,
                  projectName: authSession.projectName,
                  projectLogoURL: authSession.projectLogoURL,
                  projectId: authSession.projectId,
                  pinLength: Int64(authSession.pinLength),
                  verificationMethod: MVerificationMethod(rawValue: authSession.verificationMethod.rawValue) ?? .standardEmail ,
                  verificationURL: authSession.verificationURL,
                  verificationCustomText: authSession.verificationCustomText,
                  identityTypeLabel: authSession.identityTypeLabel,
                  quickCodeEnabled: authSession.quickCodeEnabled,
                  limitQuickCodeRegistration: authSession.limitQuickCodeRegistration,
                  identityType: MIdentityType(rawValue: authSession.identityType.rawValue) ?? .email,
                  accessId: authSession.accessId
              )
              completion(Result.success(mauthSession))
        }
      }
  }

  func getAuthenticationSessionDetailsFromPushNofitifactionPayload(
    payload: [String: String], 
    completion: @escaping (Result<MAuthenticationSessionDetails, Error>) -> Void
  ) {
      MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromPushNotificationPayload(
        pushNotificationPayload: payload
      ) { authSession, error in
        if let error = error {
            var details = [String: Any]()

            if case let AuthenticationSessionError.getAuthenticationSessionDetailsFail(authenticationSessionError) = error, let authenticationSessionError { 
              details["error"] = authenticationSessionError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
        } else if let authSession {
              let mauthSession = MAuthenticationSessionDetails(
                  userId: authSession.userId,
                  projectName: authSession.projectName,
                  projectLogoURL: authSession.projectLogoURL,
                  projectId: authSession.projectId,
                  pinLength: Int64(authSession.pinLength),
                   verificationMethod: MVerificationMethod(rawValue: authSession.verificationMethod.rawValue) ?? .standardEmail ,
                  verificationURL: authSession.verificationURL,
                  verificationCustomText: authSession.verificationCustomText,
                  identityTypeLabel: authSession.identityTypeLabel,
                  quickCodeEnabled: authSession.quickCodeEnabled,
                  limitQuickCodeRegistration: authSession.limitQuickCodeRegistration,
                  identityType: MIdentityType(rawValue: authSession.identityType.rawValue) ?? .email,
                  accessId: authSession.accessId
              )
              completion(Result.success(mauthSession))
        }
      }
  }

  func sign(
    user: MUser, 
    message: FlutterStandardTypedData, 
    pin: String,
    completion: @escaping (Result<MSigningResult, Error>
  ) -> Void) {
        let sdkUser = MIRACLTrust.getInstance().getUser(by: user.userId)

        if let sdkUser {
            MIRACLTrust.getInstance().sign(
                message: message.data ,
                user: sdkUser,
                didRequestSigningPinHandler: { pinProcessor in
                    pinProcessor(pin)
                }, completionHandler: { signingResult, error in
                    if let error = error {
                      var details = [String: Any]()

                      if case let SigningError.signingFail(signingError) = error, let signingError { 
                        details["error"] = signingError.errorDebugDescription       
                      }
                      
                      let pigeonError = self.createPigeonError(error: error, details: details)
                      completion(Result.failure(pigeonError));
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
                                timestamp: Int64((signingResult.timestamp.timeIntervalSince1970))
                            )
                        ))
                    }
                }
            )
        }
    }

  func getSigningDetailsFromQRCode(
    qrCode: String, 
    completion: @escaping (Result<MSigningSessionDetails, Error>) -> Void
  ) {
     MIRACLTrust
        .getInstance()
        .getSigningSessionDetailsFromQRCode(
            qrCode: qrCode
        ) { signingSessionDetails, error in
          if let signingSessionDetails {
            let mSigningSessionDetails = MSigningSessionDetails(
                  userId: signingSessionDetails.userId,
                  projectName: signingSessionDetails.projectName,
                  projectLogoURL: signingSessionDetails.projectLogoURL,
                  projectId: signingSessionDetails.projectId,
                  pinLength: Int64(signingSessionDetails.pinLength),
                  verificationMethod: MVerificationMethod(rawValue: signingSessionDetails.verificationMethod.rawValue) ?? .standardEmail ,
                  verificationURL: signingSessionDetails.verificationURL,
                  verificationCustomText: signingSessionDetails.verificationCustomText,
                  identityTypeLabel: signingSessionDetails.identityTypeLabel,
                  quickCodeEnabled: signingSessionDetails.quickCodeEnabled,
                  limitQuickCodeRegistration: signingSessionDetails.limitQuickCodeRegistration,
                  identityType: MIdentityType(rawValue: signingSessionDetails.identityType.rawValue) ?? .email,
                  sessionId: signingSessionDetails.sessionId,
                  signingHash: signingSessionDetails.signingHash,
                  signingDescription: signingSessionDetails.signingDescription,
                  status: MSigningSessionStatus(rawValue:signingSessionDetails.status.rawValue) ?? .active ,
                  expireTime: Int64((signingSessionDetails.expireTime.timeIntervalSince1970 * 1000.0).rounded())
            )
            completion(Result.success(mSigningSessionDetails))
          } else if let error {
            var details = [String: Any]()

            if case let SigningSessionError.getSigningSessionDetailsFail(signingSessionError) = error, let signingSessionError { 
              details["error"] = signingSessionError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
          }
        }
  }

  func getSigningSessionDetailsFromLink(
    link: String, 
    completion: @escaping (Result<MSigningSessionDetails, Error>) -> Void
  ) {
     MIRACLTrust
        .getInstance()
        .getSigningSessionDetailsFromUniversalLinkURL(
          universalLinkURL: URL(string: link)!
        ) { signingSessionDetails, error in
          if let signingSessionDetails {
            let mSigningSessionDetails = MSigningSessionDetails(
                userId: signingSessionDetails.userId,
                projectName: signingSessionDetails.projectName,
                projectLogoURL: signingSessionDetails.projectLogoURL,
                projectId: signingSessionDetails.projectId,
                pinLength: Int64(signingSessionDetails.pinLength),
                verificationMethod: MVerificationMethod(rawValue: signingSessionDetails.verificationMethod.rawValue) ?? .standardEmail,
                verificationURL: signingSessionDetails.verificationURL,
                verificationCustomText: signingSessionDetails.verificationCustomText,
                identityTypeLabel: signingSessionDetails.identityTypeLabel,
                quickCodeEnabled: signingSessionDetails.quickCodeEnabled,
                limitQuickCodeRegistration: signingSessionDetails.limitQuickCodeRegistration,
                identityType: MIdentityType(rawValue: signingSessionDetails.identityType.rawValue) ?? .email,
                sessionId: signingSessionDetails.sessionId,
                signingHash: signingSessionDetails.signingHash,
                signingDescription: signingSessionDetails.signingDescription,
                status: MSigningSessionStatus(rawValue:signingSessionDetails.status.rawValue) ?? .active ,
                expireTime: Int64((signingSessionDetails.expireTime.timeIntervalSince1970 * 1000.0).rounded())
            )
            completion(Result.success(mSigningSessionDetails))
          } else if let error {
            var details = [String: Any]()

            if case let SigningSessionError.getSigningSessionDetailsFail(signingSessionError) = error, let signingSessionError { 
              details["error"] = signingSessionError.errorDebugDescription       
            }
            
            let pigeonError = self.createPigeonError(error: error, details: details)
            completion(Result.failure(pigeonError));
          }
        }
  }

  func getUser(
    userId: String, 
    completion: @escaping (Result<MUser?, Error>) -> Void
  ) {
    if let user = MIRACLTrust.getInstance().getUser(by: userId) {
      let mUser = userToMUser(user: user)
      completion(Result.success(mUser))
    } else {
      completion(Result.success(nil))
    }
  }

  private func userToMUser(user:User) -> MUser {
      return MUser(projectId: user.projectId, revoked: user.revoked, userId: user.userId, hashedMpinId: user.hashedMpinId);
  }

  private func createPigeonError(error: any Error, details:[String: Any]? = nil) -> PigeonError {
    PigeonError(
      code: error.errorDebugDescription,
      message: String(describing: type(of: error)),
      details: details
    )
  }
}