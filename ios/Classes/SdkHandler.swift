import MIRACLTrust
import Flutter

public class SdkHandler: NSObject, MiraclSdk {

  func initSdk(
    configuration: MConfiguration, 
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    do {
        let conf = try Configuration.Builder(projectId: configuration.projectId).build()
        completion(Result.success(try MIRACLTrust.configure(with: conf)))
    } catch {
        completion(Result.failure(error))
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
    authenticationSessionDetails: MAuthenticationSessionDetails?, 
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
    MIRACLTrust.getInstance().sendVerificationEmail(userId: userId) { (result, error) in
        if let error {
            completion(Result.failure(error));
        } else {
            completion(Result.success(true))
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
                    completion(Result.failure(error))
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
                    completion(Result.failure(error))
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
    userId: String, 
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
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
          if let error = error {
              completion(Result.failure(error));
          } else if let user = user {
              completion(Result.success(self.userToMUser(user: user)))
          }
      }
  }
  
  func generateQuickCode(
    userId: String, 
    pin: String, 
    completion: @escaping (Result<MQuickCode, Error>) -> Void
  ) {
      let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
      if let sdkUser {
          MIRACLTrust.getInstance().generateQuickCode(user: sdkUser) { processPinHandler in
              processPinHandler(pin)
          } completionHandler: { quickCode, error in
              if let error = error {
                  completion(Result.failure(error));
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
                  completion(Result.failure(error));
              } else if let result = result {
                  completion(Result.success(result))
              }
          }
      }
  }

  func authenticateWithQrCode(
    userId: String, 
    pin: String,
    qrCode: String, 
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
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

  func authenticateWithLink(
    userId: String, 
    pin: String, 
    link: String, 
    completion: @escaping (Result<Bool, Error>) -> Void
  ) {
     let sdkUser = MIRACLTrust.getInstance().getUser(by: userId)
        
     if let sdkUser {
         MIRACLTrust.getInstance().authenticateWithUniversalLinkURL(
            user: sdkUser, 
            universalLinkURL: URL(string:link)!
         ) { pinProcessor in
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
        } else {
            if let error {
                completion(Result.failure(error))
            }
        }
     }
  }

  func getAuthenticationSessionDetailsFromQRCode(
    qrCode: String, 
    completion: @escaping (Result<MAuthenticationSessionDetails, Error>) -> Void
  ) {
      MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromQRCode(qrCode: qrCode) { authSession, error in
          if let error = error {
              completion(Result.failure(error));
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
            completion(Result.failure(error));
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
            completion(Result.failure(error));
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
    userId: String,
    pin: String, 
    message: FlutterStandardTypedData, 
    completion: @escaping (Result<MSigningResult, Error>
  ) -> Void) {
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
                                timestamp: Int64((signingResult.timestamp.timeIntervalSince1970 * 1000.0).rounded())
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
             completion(Result.failure(error));
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
             completion(Result.failure(error));
          }
        }
  }

  private func userToMUser(user:User) -> MUser {
      return MUser(projectId: user.projectId, revoked: user.revoked, userId: user.userId, hashedMpinId: user.hashedMpinId);
  }
}