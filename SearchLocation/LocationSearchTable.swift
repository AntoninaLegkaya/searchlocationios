//
//  LocationSearchTable.swift
//  SearchLocation
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 User. All rights reserved.
//

import Foundation
import UIKit
 import MapKit

class LocationSearchTable : UITableViewController{
    var matchingItems : [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate : HandleMapSearch? = nil
    
    func parseAddress(selectItem: MKPlacemark) -> String {
             // put space
             let firstSpace = (selectItem.subThoroughfare != nil && selectItem.thoroughfare != nil) ? " " : ""
             // put coma between street and city/state
             let comma = (selectItem.subThoroughfare != nil || selectItem.thoroughfare != nil) && (selectItem.subAdministrativeArea != nil || selectItem.administrativeArea != nil) ? ", " : ""
             // put space between city
             let secondSpace = (selectItem.subAdministrativeArea != nil && selectItem.administrativeArea != nil) ? " " : ""
             let addressLine = String(
                 format: "%@%@%@%@%@%@%@",
                 //street number
                 selectItem.subThoroughfare ?? "",
                 firstSpace,
                 //streetName
                 selectItem.thoroughfare ?? "",
                 comma,
                 //city
                 selectItem.locality ?? "",
                 secondSpace,
                 //state
                 selectItem.administrativeArea ?? ""
             )
             return addressLine
         }
}
extension LocationSearchTable : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start{   (response, err) in
                 guard  let response = response else {
                    print(err.debugDescription)
                    return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
    }
        
      
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let selectedItem = matchingItems[indexPath.row].placemark
    cell.textLabel?.text = selectedItem.name
    cell.detailTextLabel?.text = parseAddress(selectItem: selectedItem)
    return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        // pass the placemark to the map controller via the custom protocol method
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

