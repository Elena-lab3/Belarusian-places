//
//  ViewController.swift
//  places
//
//  Created by Елена Барковская on 4.08.22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataFromRequest: String = ""
    var arJson: [Dictionary<String,Any>] = []
    
    @IBOutlet weak var cityTable: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        AF.request("https://krokapp.by/api/get_cities/11/").response(){(response) in
                        if let data = response.data {
                                self.dataFromRequest = String(data: data, encoding: .utf8)!
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: Data(self.dataFromRequest.utf8), options :[]) as? [Dictionary<String,Any>]
                                    {
                                    for i in 8...12 where i % 2 == 0{
                                        self.arJson.append(jsonArray[i])
                                    }
                                    for i in 13...17 where i % 2 != 0{
                                        self.arJson.append(jsonArray[i])
                                    }
                                    print(self.arJson)
                                    self.cityTable.delegate = self
                                    self.cityTable.dataSource = self
                                    
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
        print(self.arJson.count)
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        guard let receivedImage = try? Data(contentsOf: URL(string: self.arJson[indexPath.row]["logo"] as! String)!)
        else{
            return cell
        }
        cell.imageView?.image = UIImage(data: receivedImage)
        cell.textLabel?.text = self.arJson[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showDet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PlacesViewController{
            dest.cityId = self.arJson[cityTable.indexPathForSelectedRow!.row]["id"] as! Int
            dest.cityName = self.arJson[cityTable.indexPathForSelectedRow!.row]["name"] as! String
        }
    }

}

