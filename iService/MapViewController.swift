//
//  MapViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 22/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var point = CarAnnotation?()
    var locationManager: CLLocationManager!
    @IBOutlet var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for user permission to access location infos
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Show the user current location
        mapview.showsUserLocation = true
        mapview.delegate = self
    }
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        addAnnotations()
        let region = MKCoordinateRegion(center: self.mapview.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    //Setup the annotation view with Accept, Request and Directions actions.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type CarAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is CarAnnotation){
            return nil
        }
        
        var annotationView = self.mapview.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
            
        }else{
            annotationView?.annotation = annotation
        }
        
        // Left Accessory view
        let segmentedControl = UISegmentedControl()
        segmentedControl.frame = CGRectMake(100, 200, 200, 30)
        segmentedControl.insertSegmentWithTitle("Accept", atIndex: 0, animated: true)
        segmentedControl.insertSegmentWithTitle("Reject", atIndex: 1, animated: true)
        segmentedControl.tintColor = UIColor.redColor()
        segmentedControl.selected = false
        segmentedControl.addTarget(self, action: "segment:", forControlEvents: .ValueChanged)
        annotationView?.leftCalloutAccessoryView = segmentedControl
        
        // Right accessory view
        let showDirections = UIButton()
        showDirections.setTitle("Get Directions", forState: .Normal)
        showDirections.setTitleColor(UIColor.blackColor(), forState: .Normal)
        showDirections.frame = CGRectMake(0, 0, 30, 30)
        showDirections.addTarget(self, action: "directionsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        let image = UIImage(named: "directions.png")
        showDirections.setImage(image, forState: .Normal)
        annotationView?.rightCalloutAccessoryView = showDirections
        
        return annotationView
    }
    
    //Function to control directions icon of call-out.
    //Might not be needed as delegate method does the job.
    func directionsTapped(sender: AnyObject) {
        print("Directions tapped")
    }
    
    //Function to control segmented control of callout
    func segment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Request Accepted")
        } else {
            print("Request Denied")
        }
        
        let selectedAnnotations = mapview.selectedAnnotations
        for annotation in selectedAnnotations {
            mapview.deselectAnnotation(annotation, animated: false)
        }
    }
    
    //Delegate method
    //Function to show directions when direction image of callout is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        // The map item is the customer location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    //Add annotations on the screen.
    func addAnnotations() {
        addAnnotation1()
        addAnnotation2()
        addAnnotation3()
    }
    
    func addAnnotation1() {
        
        let latitude: Double   = mapview.userLocation.coordinate.latitude + 0.01
        let longitude: Double  = mapview.userLocation.coordinate.longitude + 0.01
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = "Bronze"
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    func addAnnotation2() {
        
        let latitude: Double   = mapview.userLocation.coordinate.latitude + 0.02
        let longitude: Double  = mapview.userLocation.coordinate.longitude + 0.02
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = "Gold"
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    func addAnnotation3() {
        
        let latitude: Double   = mapview.userLocation.coordinate.latitude - 0.02
        let longitude: Double  = mapview.userLocation.coordinate.longitude - 0.02
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = "Silver"
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    //Prepare for Segue, for logout. Currently logout is done from logout action. Need to change it back to PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
            PFUser.logOut()
            self.tabBarController?.tabBar.hidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            print("User has been logged out")
        }
    }
    
    //Action for Logout
    @IBAction func logoutTapped(sender: AnyObject) {
        
        PFUser.logOut()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customerVC = storyboard.instantiateViewControllerWithIdentifier("vireController")
        self.presentViewController(customerVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
