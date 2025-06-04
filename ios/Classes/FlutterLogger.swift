import MIRACLTrust

final class FlutterLogger: Logger {
    final let mLogger: MLogger

    init(mLogger: MLogger){
      self.mLogger = mLogger
    }

    func debug(message: String, category: LogCategory) {
        DispatchQueue.main.async {
            let categoryAsString = self.getCategoryAsString(category: category)
            self.mLogger.debug(category:categoryAsString, message: message) { _ in }
        }
    }
    
    func info(message: String, category: LogCategory) {
        DispatchQueue.main.async {
            let categoryAsString = self.getCategoryAsString(category: category)
            self.mLogger.info(category:categoryAsString, message: message) { _ in }
        }
    }
    
    func warning(message: String, category: LogCategory) {
        DispatchQueue.main.async {            
            let categoryAsString = self.getCategoryAsString(category: category)
            self.mLogger.warning(category:categoryAsString, message: message) { _ in }
        }
    }
    
    func error(message: String, category: LogCategory) {
        DispatchQueue.main.async {
            let categoryAsString = self.getCategoryAsString(category: category)
            self.mLogger.error(category:categoryAsString, message: message) { _ in }
        }
    }

    private func getCategoryAsString(category: LogCategory) -> String {
      switch category {
        case .configuration:
            return "configuration"
        case .networking:
            return "networking"
        case .crypto:
            return "crypto"
        case .registration:
            return "registration"
        case .authentication:
            return "authentication"
        case .signing:
            return "signing"
        case .signingRegistration:
            return "signing registration"
        case .verification:
            return "verification"
        case .verificationConfirmation:
            return "verification confirmation"
        case .storage:
            return "storage"
        case .sessionManagement:
            return "Session Management"
        case .jwtGeneration:
            return "JWT Generation"
        case .quickCode:
            return "QuickCode"
        default:
            return ""
        }
    }
}
