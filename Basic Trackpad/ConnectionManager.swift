//
//  ConnectionManager.swift
//  Basic Trackpad
//
//  Created by Tomasz Pieczykolan on 17/12/16.
//  Copyright © 2016 Tomasz Pieczykolan. All rights reserved.
//

import MultipeerConnectivity

class ConnectionManager: NSObject, MCSessionDelegate {
    
    static let shared = ConnectionManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Setup
    
    var peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    lazy var session: MCSession = {
        let s = MCSession(peer: self.peerID)
        s.delegate = self
        return s
    }()
    
    lazy var browser: MCBrowserViewController = MCBrowserViewController(serviceType: serviceType, session: self.session)
    
    // MARK: - Settings
    
    var mouseAcceleration: CGFloat = {
        UserDefaults.standard.register(defaults: [mouseAccelerationValueKey: Float(1.30)])
        return CGFloat(UserDefaults.standard.float(forKey: mouseAccelerationValueKey))
    }()
    
    // MARK: - Data transfer
    
    func send(movement: CGVector) {
        var mov = movement
        let data = Data(bytes: &mov, count: MemoryLayout<CGVector>.size)
        do {
            try self.session.send(data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
    }
    
    func send(mouseDown: Bool) {
        var down = mouseDown
        let data = Data(bytes: &down, count: MemoryLayout<Bool>.size)
        do {
            try self.session.send(data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch {
            print(error)
        }
    }
    
    func send(mouseEventCode: UInt16) {
        var code = mouseEventCode
        let data = Data(bytes: &code, count: MemoryLayout<UInt16>.size)
        do {
            try self.session.send(data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch {
            print(error)
        }
    }
    
    // MARK: - MCSessionDelegate
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function, peerID.displayName, state.rawValue)
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print(#function)
    }
}
