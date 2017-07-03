//
//  LocationPickingViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class LocationPickingTableCell: UITableViewCell {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}





class LocationPickingViewController: UIViewController {
    
    @IBOutlet weak var locationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.locationsTable.dataSource = self
        self.locationsTable.delegate = self
        self.locationsTable.estimatedRowHeight = 40.0
        self.locationsTable.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = "Location"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationPickingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return RattitLocationManager.sharedInstance.loadedNearbyPlacesFromGoogle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HideLocationCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPickingTableCell", for: indexPath) as! LocationPickingTableCell
            let loadedlocation = RattitLocationManager.sharedInstance.loadedNearbyPlacesFromGoogle[indexPath.row]
            
            cell.locationNameLabel.text = loadedlocation.name
            cell.addressLabel.text = loadedlocation.addressStr
            cell.distanceLabel.text = RattitLocationManager.sharedInstance.getDistanceFromCurrentLocation(forLocation: loadedlocation.cLocationPoint)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            ComposeContentManager.sharedInstance.pickedPlaceFromGoogle = nil
            ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 0
        } else {
            ComposeContentManager.sharedInstance.pickedPlaceFromGoogle = RattitLocationManager.sharedInstance.loadedNearbyPlacesFromGoogle[indexPath.row]
            ComposeContentManager.sharedInstance.pickedPlaceRatingValue = 0
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            headerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 15.0)
            headerView.backgroundColor = UIColor(red: 0.9255, green: 0.9255, blue: 0.9255, alpha: 1.0)
            return headerView
        }
        return nil
    }
    
}
