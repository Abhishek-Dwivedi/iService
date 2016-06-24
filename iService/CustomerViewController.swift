
//
//  CustomerViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 19/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import Parse
import MapKit

class CustomerViewController: UIViewController,MKMapViewDelegate {
    
    var point = CarAnnotation?()
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var serviceMyCarButton: UIButton!
    
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
    //Delegate method to setup the map
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        addAnnotations()
        let region = MKCoordinateRegion(center: self.mapview.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    //Setup the annotation view with car image and "Request a service" callout"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // If annotation is not of type CarAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is CarAnnotation){
            return nil
        }
        
        var annotationView = self.mapview.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "sportscar.png")
            annotationView?.bounds = CGRectMake(0, 0, 10, 22.5)
        }else{
            annotationView?.annotation = annotation
        }
        
        // Right accessory view
        
        let showDirections = UIButton()
        showDirections.setTitle("Request a Service", forState: .Normal)
        showDirections.setTitleColor(UIColor.blackColor(), forState: .Normal)
        showDirections.frame = CGRectMake(0, 0, 150, 30)
        showDirections.addTarget(self, action: "directionsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        annotationView?.rightCalloutAccessoryView = showDirections

        return annotationView
    }
    
    //Using Gesture Recognizers
    /*
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: Selector("annotationTapped:"))
        view.addGestureRecognizer(gesture)
    }
    
    func annotationTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formVC = storyboard.instantiateViewControllerWithIdentifier("formVC") as! RequestFormViewController
        let navigationController = UINavigationController(rootViewController: formVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
        for annotation in self.mapview.annotations {
            self.mapview.deselectAnnotation(annotation, animated: false)
        }
    }
    */
    
    //Delegate method when callout of the annotation is clicked
    //Goes to RequestFormViewController when callout is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formVC = storyboard.instantiateViewControllerWithIdentifier("formVC") as! RequestFormViewController
        let navigationController = UINavigationController(rootViewController: formVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
        for annotation in self.mapview.annotations {
            self.mapview.deselectAnnotation(annotation, animated: false)
        }
    }
    
    //Alert to show the user that request has been submitted
    func showRequestSubmittedAlert() {
        let alert = UIAlertController(title: "Service Request", message: "Your service request has been submitted.", preferredStyle:.Alert)
        
        let action = UIAlertAction(title: "Button1", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Okay tapped")
        })
        
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    //Helper Alert method
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //Add annotations near user's location
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
        point!.title = " "
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    func addAnnotation2() {
        
        let latitude: Double   = mapview.userLocation.coordinate.latitude + 0.02
        let longitude: Double  = mapview.userLocation.coordinate.longitude + 0.02
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = " "
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    func addAnnotation3() {
        
        let latitude: Double   = mapview.userLocation.coordinate.latitude - 0.02
        let longitude: Double  = mapview.userLocation.coordinate.longitude - 0.02
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = " "
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }

    //Action when "Service My Car" is tapped which is at the bottom of the screen
    @IBAction func serviceMyCarTapped(sender: AnyObject) {
        print("Service my car tapped")
    }
    
    //Prepare for segue. Used to logout.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
            print("User has been logged out")
        }
    }
    
    //Dismiss the ViewController once logged out
    @IBAction func logoutTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
