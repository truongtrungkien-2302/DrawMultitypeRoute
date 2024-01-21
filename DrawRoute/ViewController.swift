//
//  ViewController.swift
//  DrawRoute
//
//  Created by Truong Trung Kien on 21/01/2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
//        self.showRouteV1()
        self.showRouteV2()
    }
    
    private func showRouteV2() {
        let location1 = CLLocationCoordinate2D(latitude: 21.006947, longitude: 105.810064)
        let location2 = CLLocationCoordinate2D(latitude: 21.008129, longitude: 105.808691)
        let location3 = CLLocationCoordinate2D(latitude: 21.010934, longitude: 105.811009)
        let location4 = CLLocationCoordinate2D(latitude: 21.015601, longitude: 105.805108)
        let location5 = CLLocationCoordinate2D(latitude: 21.028400, longitude: 105.805357)
        let location6 = CLLocationCoordinate2D(latitude: 21.041984, longitude: 105.816656)
        let location7 = CLLocationCoordinate2D(latitude: 21.039634, longitude: 105.828555)
        let location8 = CLLocationCoordinate2D(latitude: 21.041398, longitude: 105.830441)
        
        var listCLLocationCoordinate2D: [CLLocationCoordinate2D] = []
        listCLLocationCoordinate2D.append(location1)
        listCLLocationCoordinate2D.append(location2)
        listCLLocationCoordinate2D.append(location3)
        listCLLocationCoordinate2D.append(location4)
        listCLLocationCoordinate2D.append(location5)
        listCLLocationCoordinate2D.append(location6)
        listCLLocationCoordinate2D.append(location7)
        listCLLocationCoordinate2D.append(location8)
        
        for i in 0...listCLLocationCoordinate2D.count {
            if i+1 < listCLLocationCoordinate2D.count {
                print("TTKIEN i: \(i) ~ i+1: \(i+1) ~ count: \(listCLLocationCoordinate2D.count)")
                self.showRouteOnMap(pickUpCoordinate: listCLLocationCoordinate2D[i], destinationCoordinate: listCLLocationCoordinate2D[i+1])
            }
        }
    }

    private func showRouteV1() {
        let pickUpCoordinate = CLLocationCoordinate2D(latitude: 21.006947, longitude: 105.810064)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 21.041398, longitude: 105.830441)
        self.showRouteOnMap(pickUpCoordinate: pickUpCoordinate, destinationCoordinate: destinationCoordinate)
    }

}

extension ViewController: MKMapViewDelegate {
    func showRouteOnMap(pickUpCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickUpCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5
        return renderer
    }
    
}
