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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RattitLocationManager.sharedInstance.loadedNearbyPlacesFromGoogle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPickingTableCell", for: indexPath) as! LocationPickingTableCell
        let loadedlocation = RattitLocationManager.sharedInstance.loadedNearbyPlacesFromGoogle[indexPath.row]
        
        cell.locationNameLabel.text = loadedlocation.name
        cell.addressLabel.text = loadedlocation.addressStr
        cell.distanceLabel.text = RattitLocationManager.sharedInstance.getDistanceFromCurrentLocation(forLocation: loadedlocation.cLocationPoint)
        
        
        return cell
    }
    
    
}
