//
//  PlacesViewController.swift
//  places
//
//  Created by Елена Барковская on 5.08.22.
//

import UIKit
import Alamofire

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var placeTable: UITableView!
    
    var cityId: Int = 0
    var cityName: String = ""
    var dataFromRequest: String = ""
    var placesArray: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = .orange
        
        titleLable.text = "\(cityName)"
        
        AF.request("https://krokapp.by/api/get_points/11/").response(){(response) in
                        if let data = response.data {
                                self.dataFromRequest = String(data: data, encoding: .utf8)!
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: Data(self.dataFromRequest.utf8), options :[]) as? [Dictionary<String,Any>]
                                    {
                                    for i in 0...jsonArray.count-1 where jsonArray[i]["city_id"] as! Int == self.cityId{
                                        self.placesArray.append(jsonArray[i])
                                        }
                                    print(jsonArray[0])
                                    self.placeTable.delegate = self
                                    self.placeTable.dataSource = self

                                        } else {
                                            print("bad json")
                                        }
                                } catch let error as NSError {
                                        print(error)
                                }
                            }
                        
                }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        guard let receivedImage = try? Data(contentsOf: URL(string: self.placesArray[indexPath.row]["logo"] as! String)!)
        else{
            return cell
        }
        cell.imageView?.image = UIImage(data: receivedImage)
        cell.textLabel?.text = self.placesArray[indexPath.row]["name"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toInformation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? InformationViewController{
            dest.descrText = (self.placesArray[placeTable.indexPathForSelectedRow!.row]["text"] as? String)!
            dest.mainImage = self.placesArray[placeTable.indexPathForSelectedRow!.row]["photo"] as! String
            dest.placeName = self.placesArray[placeTable.indexPathForSelectedRow!.row]["name"] as! String
            dest.publicationDate = self.placesArray[placeTable.indexPathForSelectedRow!.row]["creation_date"] as! String
            dest.song = URL.init(string: self.placesArray[placeTable.indexPathForSelectedRow!.row]["sound"] as! String)
            
        }
    }

}
