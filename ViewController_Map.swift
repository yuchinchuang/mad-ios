//
//  ViewController_Map.swift
//  MAD_Assignment2
//
//  Created by Sok Chea Amy on 10/29/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit
import MapKit

class ViewController_Map: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    var address : String = ""
    var mapDistance : Double = 1000
    
    // location marker
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var err: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pintAnnotationView: MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // remove previous markers
        if self.map.annotations.count != 0 {
            annotation = self.map.annotations[0]
            self.map.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, err) -> Void in
            // no result found -> notification
            if localSearchResponse == nil {
                let alert = UIAlertController (title: "Oops", message: "Address not found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // found address -> mark on map
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.address
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.pintAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(self.pintAnnotationView.annotation!)
        }
        
    }

    @IBAction func ZoomIn(_ sender: Any) {
        mapDistance = mapDistance - 2000
        if mapDistance < 100 {
            mapDistance = 100
        }
        let region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, mapDistance, mapDistance)
        map.setRegion(region, animated: true)
    }
    
    
    @IBAction func ZoomOut(_ sender: Any) {
        mapDistance += 2000
        let region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, mapDistance, mapDistance)
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ChangeMapType(_ sender: Any) {
        if map.mapType == MKMapType.standard {
            map.mapType = MKMapType.satellite
        }
        else {
            map.mapType = MKMapType.standard
        }
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
