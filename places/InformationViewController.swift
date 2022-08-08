//
//  InformationViewController.swift
//  places
//
//  Created by Елена Барковская on 5.08.22.
//

import UIKit
import AVKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionString: UILabel!
    @IBOutlet weak var publicationDateString: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var navigItem: UINavigationItem!
    @IBOutlet weak var nameString: UILabel!
    
    
    var descrText: String = ""
    var mainImage: String = ""
    var publicationDate: String = ""
    var song: URL?
    var placeName: String = ""
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionString.text = String(htmlEncodedString: descrText)
        nameString.text = placeName
        publicationDateString.text = "Дата публікацыі: \(String(htmlEncodedString: publicationDate)!)"
        
        guard let receivedImage = try? Data(contentsOf: URL(string: mainImage)!)
        else{
            return
        }
        image.image = UIImage(data: receivedImage)
    }
    
    func play(url:URL) {
        print("playing \(url)")

        do {

            let playerItem = AVPlayerItem(url: url)

            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

    @IBAction func playButton(_ sender: Any) {
        print("AAAAA")
        play(url: song!)
    }
}


extension String {
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
        
        self.init(attributedString.string)
    }
}
