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
        
        //TODO: criar um MCPeerID
        
        //TODO: criar uma MCSession
        
        //TODO: criar um advertiser para começar a transmitir
        
        //TODO: criar um browser para começar a procurar peers
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
        //TODO: enviar mensagem para os peers conectados
    }
    
    
    //MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //TODO: enviar um convite quando achar um peer
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //do something when the connection with a peer is lost
    }
    
    
    //MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //TODO: aceitar o convite quando receber um
    }
    
    //MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //TODO: printar qual o status
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //TODO: tratar o recebimento da mensagem
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
