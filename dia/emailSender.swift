import SwiftUI
import UIKit
import MessageUI
import SQLite

enum emailErorrs: Error {
    case nilEmail
    case mailApp
}

class emailSender: NSObject, MFMailComposeViewControllerDelegate {
    
    public static let shared = emailSender()

    func sendEmail(subject:String, body:String, to:String, xlsxFile: Data) throws {
        guard MFMailComposeViewController.canSendMail() else {
            throw emailErorrs.mailApp
        }
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
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

func findAdress() throws -> String {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users_info = Table("usermac")
        let doc = Expression<String?>("doc")
        var doc_adress: [String] = []
        for i in try db.prepare(users_info.select(doc)) {
            guard i[doc] != nil else {
                throw emailErorrs.nilEmail
            }
            doc_adress.append(i[doc]!)
        }
        return doc_adress.first!
    }
    catch {
        print(error)
        return ""
    }
}
