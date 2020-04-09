import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    @IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    var serviceType = "chat-teste"
    
    var peerID: MCPeerID!
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
    @IBAction func didPressSend(_ sender: Any) {
        self.send(text: textField.text ?? "")
    }
    
    func printMessage(_ message: String, from sender: String? = nil) {
        var text = "\n"
        if let sender = sender {
            text += "\(sender): "
        }
        text += message
        DispatchQueue.main.async { [unowned self] in
            self.chatView.text += text
        }
    }
    
    func send(text: String) {
        guard session.connectedPeers.count > 0, let data = text.data(using: .unicode) else { return }
        
        do {
            try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            printMessage(text, from: "YOU")
        } catch let error{
            printMessage(error.localizedDescription)
            printMessage("erro ao enviar")
        }
    }
    
    
    //MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 60)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //do something when the connection with a peer is lost
    }
    
    
    //MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    //MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            printMessage("\(peerID.displayName) se conectou a sala.")
            print("connected to: \(peerID.displayName)")
        case .connecting:
            print("connecting to: \(peerID.displayName)")
        case .notConnected:
            print("not connected to: \(peerID.displayName)")
        @unknown default:
            print("unknown state (\(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .unicode) else { return }
        printMessage(message, from: peerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //do something when a data stream is received
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //do something when resource starts being received
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //do something when resource has been received
    }
}
