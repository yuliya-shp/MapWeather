//
//  ViewController.swift
//  MapApp
//
//
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func mapTap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        showInfo(coordinate: locationCoordinate)
    }
    
    @IBAction func currentTap(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            render(location: location)
        }
    }
    
    func render(location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        showInfo(coordinate: coordinate)
    }
    
    func showInfo(coordinate: CLLocationCoordinate2D) {
        Manager.shared.getData(coordinates: coordinate) { weather in
            DispatchQueue.main.async {
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                if let weather = weather {
                    point.title = "Temperature: \(weather.main.temp) °C \nFeels like: \(weather.main.feels_like) °C"
                    point.subtitle = "max: \(weather.main.temp_max) °C\nmin: \(weather.main.temp_min) °C"
                } else {
                    point.title = "error"
                }
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                self.mapView.addAnnotation(point)
            }
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            if response == nil
            {
                print("Error")
            }
            else
            {
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.showInfo(coordinate: coordinates)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
}

