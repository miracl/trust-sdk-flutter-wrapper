import MIRACLTrust

extension CrossDeviceSession {
    func toMCrossDeviceSession() -> MCrossDeviceSession {
        MCrossDeviceSession(
            sessionId: sessionId,
            sessionDescription: sessionDescription,
            userId: userId,
            projectId: projectId,
            signingHash: signingHash
        )
    }
}

extension MCrossDeviceSession {
    func toCrossDeviceSession() -> CrossDeviceSession {
        CrossDeviceSession(
            userId: userId,
            projectId: projectId,
            sessionId: sessionId,
            sessionDescription: sessionDescription,
            signingHash: signingHash
        )
    }
}
