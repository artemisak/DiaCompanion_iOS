import Foundation
import MessageUI

class emailSender: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = emailSender()

    func sendEmail(subject:String, body:String, to:String){
        if MFMailComposeViewController.canSendMail() {
            let picker = MFMailComposeViewController()
            picker.setSubject(subject)
            picker.setMessageBody(body, isHTML: true)
            picker.setToRecipients([to])
            picker.addAttachmentData("Some text".data(using: .utf8)!, mimeType: "text/plain", fileName: "text.txt")
            picker.mailComposeDelegate = self
            UIApplication.shared.currentUIWindow()?.rootViewController?.present(picker, animated: true, completion: nil)
        } else {
            print("Не установлен почтовый клиент")
        }

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UIApplication.shared.currentUIWindow()?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
