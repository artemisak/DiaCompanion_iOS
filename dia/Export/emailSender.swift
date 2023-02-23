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
    
    private override init() {
    }

    func sendEmail(subject:String, body:String, to: [String], xlsxFile: Data) throws {
        guard MFMailComposeViewController.canSendMail() else {
            throw emailErorrs.mailApp
        }
        let sender = MFMailComposeViewController()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        sender.view.tintColor = UIColor(red: 51/255, green: 119/255, blue: 246/255, alpha: 1)
        sender.mailComposeDelegate = self
        sender.setSubject(subject)
        sender.setMessageBody(body, isHTML: true)
        sender.setToRecipients(to)
        sender.overrideUserInterfaceStyle = .light
        sender.addAttachmentData(xlsxFile, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: "Dial\(findPacientname()![0][0]+" "+findPacientname()![0][1]+" "+dateFormatter.string(from: date)).xlsx")
        UIApplication.shared.currentUIWindow()?.rootViewController?.present(sender, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

func findAdress() throws -> [String] {
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
        switch doc_adress.first! {
        case "Анопова Анна Дмитриевна":
            return ["anopova.ann@gmail.com","diacompanion@gmail.com"]
        case "Болотько Яна Алексеевна":
            return ["yanabolotko@gmail.com","diacompanion@gmail.com"]
        case "Дронова Александра Владимировна":
            return ["aleksandra-dronova@yandex.ru","diacompanion@gmail.com"]
        case "Попова Полина Викторовна":
            return ["pvpopova@yandex.ru","diacompanion@gmail.com"]
        case "Ткачук Александра Сергеевна":
            return ["aleksandra.tkachuk.1988@mail.com","diacompanion@gmail.com"]
        case "Васюкова Елена Андреева":
            return ["elenavasukova2@gmail.com","diacompanion@gmail.com"]
        case "Пашкова Кристина Валерьевна":
            return ["kristinapaskova95@gmail.com","diacompanion@gmail.com"]
        default:
            return [""]
        }
    }
    catch {
        print(error)
        return [""]
    }
}

func findPacientname() -> [[String]]? {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users_info = Table("usermac")
        let fio = Expression<String?>("fio")
        let id = Expression<Int?>("id")
        var metaInfo: [[String]] = []
        for i in try db.prepare(users_info.select(id, fio)){
            metaInfo.append([String(i[id] ?? 1), i[fio] ?? "Новый пользователь"])
        }
        return metaInfo
    }
    catch {
        print(error)
        return nil
    }
}
