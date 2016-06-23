//
//  AdminTableViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 19/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import Parse

class AdminTableViewController: UITableViewController,CLLocationManagerDelegate {

    var manager = CLLocationManager()
    var objects: [PFObject]?
    var locationsArray = [CLLocation]()
    var ETAArray = [String]()
    var usernames = [String]()
    var plansArray = [String]()
    
    @IBOutlet var requestsTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //Setup data
        usernames = ["9734765412", "9867437812", "8976565911"]
        ETAArray = ["3.2 miles away", "2.6 miles away", "3.7 miles away"]
        plansArray = ["Silver", "Gold", "Bronze"]
    }

    // MARK: - Table view data source methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = usernames[indexPath.row]
        cell.detailTextLabel?.text = plansArray[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //Set up different backgrounds for cells
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 1.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        }
    }
    
    //Gets user location and setup three nearly locations for annotations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        manager.stopUpdatingLocation()
        
        let location1 = CLLocation(latitude: location.coordinate.latitude + 0.01, longitude: location.coordinate.longitude + 0.01)
        let location2 = CLLocation(latitude: location.coordinate.latitude + 0.02, longitude: location.coordinate.longitude + 0.02)
        let location3 = CLLocation(latitude: location.coordinate.latitude - 0.02, longitude: location.coordinate.longitude - 0.02)
        locationsArray = [location1, location2, location3]
    }
    
    //Prepare for Segue. One for logout, another for show customer when admin selects a request from the table.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "adminLogout" {
            PFUser.logOut()
            self.tabBarController?.tabBar.hidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            print("User has been logged out")
        }
        if segue.identifier == "showCustomer" {
            
            let row = requestsTableview.indexPathForSelectedRow?.row
            let vc = segue.destinationViewController as? ShowCustomerOnMapVC
            vc?.customerUsername = usernames[row!]
            vc?.customerLocation = locationsArray[row!]
            vc?.selectedPlan = plansArray[row!]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
