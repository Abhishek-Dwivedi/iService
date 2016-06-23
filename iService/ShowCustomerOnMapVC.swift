//
//  ShowCustomerOnMapVC.swift
//  iService
//
//  Created by Abhishek Dwivedi on 19/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import Parse
import MapKit

class ShowCustomerOnMapVC: UIViewController,MKMapViewDelegate {

    var customerLocation: CLLocation?
    var customerUsername: String?
    var selectedPlan: String?
    
    var manager = CLLocationManager()
    var point = CarAnnotation?()


    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //manager.dele
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        mapview.showsUserLocation = true
        mapview.delegate = self
    }
    
    //MARK: MKMapViewDelegate
    //Set up map and the selected request annotation.
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        addAnnotation()
        let region = MKCoordinateRegion(center: self.mapview.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    //Setup the annotation view with Accept, Reject and Directions actions.
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
    
    //Function to show directions when direction image of callout is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        // The map item is the restaurant location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }

    //Add annotation for the selected reuquest
    func addAnnotation() {

        let latitude = customerLocation?.coordinate.latitude
        let longitude = customerLocation?.coordinate.longitude
        
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        point = CarAnnotation(coordinate: locationCoordinates)
        point!.title = self.selectedPlan
        
        mapview.setCenterCoordinate(mapview.userLocation.coordinate, animated: true)
        
        self.mapview.addAnnotation(self.point!)
    }
    
    //Calculates the distance between customer and admin
    func getDistance() {

        let adminLocation = CLLocation(latitude: self.mapview.userLocation.coordinate.latitude, longitude: self.mapview.userLocation.coordinate.longitude)
        let custLocation = CLLocation(latitude: customerLocation!.coordinate.latitude, longitude: customerLocation!.coordinate.latitude)
        let distance = adminLocation.distanceFromLocation(custLocation)
        let miles = distance * 0.000621371
        print("ETA :: \(miles) miles")
    }
}
