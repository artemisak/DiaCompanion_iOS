import SwiftUI
import UIKit
import MessageUI

class emailSender: NSObject, MFMailComposeViewControllerDelegate {
    
    public static let shared = emailSender()

    func sendEmail(subject:String, body:String, to:String, xlsxFile: Data) {
        if MFMailComposeViewController.canSendMail() {
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.title = "Электронный дневник"
            picker.modalPresentationStyle = .fullScreen
            picker.navigationBar.tintColor = UIColor(red: 0.20, green: 0.47, blue: 0.96, alpha: 1)
            picker.setSubject(subject)
            picker.setMessageBody(body, isHTML: true)
            picker.setToRecipients([to])
            picker.addAttachmentData(xlsxFile, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: "ИсаковАО.xlsx")
            UIApplication.shared.currentUIWindow()?.rootViewController?.present(picker, animated: true, completion: nil)
        } else {
            print("Не установлен почтовый клиент")
        }

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
