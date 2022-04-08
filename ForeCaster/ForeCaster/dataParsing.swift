//
//  All Decoding.swift
//  Json test fresh start
//
//  Created by Samuel Conry-Murray (student LM) on 1/21/22.
//

import Foundation
import CoreLocation

func URLForm(_ address : String = "618 Schiller Ave", city : String = "Merion Station", state : String = "PA", zip : String = "19066") -> String{//function reads in an address and outputs a string url
    var finalURL  = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address="//static portion of the URL that holds the paramaters we dont need to change
    let URLEnd = "&benchmark=2020&format=json"//same as above but we stick it on the back
    finalURL = finalURL+address.replacingOccurrences(of: " ", with: "+")+"%2C+"+city.replacingOccurrences(of: " ", with: "+")+"%2C+"+state+"+"+zip+URLEnd//creates the URL replacing spaces with plus signs and adding other things in between that are nessecary for the link to function
    //print("In URLForm: "+finalURL)//prints for debug
    return finalURL//returns the url
}

var addressURL = URLForm()//inital URL containing the user's address
class Decoded : ObservableObject{
    @Published var geocode = Recived()//variable containing the geocoding json's results
    @Published var weather = WResponse()//variable containing the weather json's results
    @Published var dForecast = DForecast()//variable containing the daily forcast json's results
    @Published var hForecast = HForecast()//variable containing the hourly forcast json's results
    var locationManager = LocationManager.shared
    
    init() {
        if locationManager.userLocation == nil{
        decodeGeo()//starts the decoding process on initilization
        }
        else{
            
            decodeWeather(link: "https://api.weather.gov/points/\(locationManager.userLocation?.coordinate.latitude ?? 40),\(locationManager.userLocation?.coordinate.longitude ?? -74)")
        }
    }
    
    func decodeGeo(){//decodes the geocoding json given inital URL
        
        guard let gurl = URL(string: addressURL) else {print("Bad link: \(addressURL)");return}//declares the URL for the json
        
        
        URLSession.shared.dataTask(with: gurl) { (data, response, errors) in
            guard let data = data else {print("No data");return}//declares the data variable
            
            
            
            let decoderTwo = JSONDecoder()//declares decoder, its decoderTwo because of a test i did in debug
            if let geocode = try? decoderTwo.decode(Recived.self, from: data) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {//decodes, makes sure it is delayed and decodes before the others
                    self.geocode = geocode
                    //print("In decoder: "+String(self.geocode.result.addressMatches[0].coordinates.x))//prints for debug
                    self.decodeWeather(link: "https://api.weather.gov/points/"+String(self.geocode.result.addressMatches[0].coordinates.y)+","+String(self.geocode.result.addressMatches[0].coordinates.x))//starts the next decoder and passes its URL based on decoded info
                }
            }
            else{
                print("None ")//debug if it messes up
            }
        }.resume()
    }
    
    
    
    
    var link = ""
    func decodeWeather(link : String){
        
        guard let wurl = URL(string: link) else {print("Bad Link: \(link)");return}//declares URL for use
        
        URLSession.shared.dataTask(with: wurl) { (data, response, errors) in
            guard let Data = data else {print("Error");return}//data
            //print("In FetchWeather: "+link)//for debug
            
            
            let decoderOne = JSONDecoder()//declares decoder
            if let response = try? decoderOne.decode(WResponse.self, from: Data) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {//delays calling the next functions so it can finish decoding
                    self.weather = response
                //print("Link in FetchWeather: "+response.properties.forecast)//for debug
                self.decodeForcast(link: self.weather.properties.forecast.replacingOccurrences(of: " ", with: ""))//calls the function to decode daily forcast, removing spaces was an attempt to debug
                self.decodeForcast(link: self.weather.properties.forecastHourly.replacingOccurrences(of: " ", with: ""))//calls the function to decode hourly forcast, removing spaces was an attempt to debug
                }
            }
        }.resume()
    }
    func decodeForcast(link : String){//decoder for forcasts
        //print("Forecast link: "+link)//for debug
        if link.last == "y"{//checks the end of the link for a y, hourly link ends with y and the daily does not, allows it to differentiate
        let furl = URL(string: link)!//declares url
        URLSession.shared.dataTask(with: furl) { (data, response, errors) in
            
            guard let Data = data else {print("Error");return}//declares data
            
            
            
            let decoderOne = JSONDecoder()//declares decoder
            if let forecast = try? decoderOne.decode(HForecast.self, from: Data) {//decodes to HForcast, "H" for hourly
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {//delay to make sure it finishes
                    self.hForecast = forecast
                }
                
            }
        }.resume()
    }
        else{//doesnt end with y thus it is daily
            let furl = URL(string: link)!//declares URL
            URLSession.shared.dataTask(with: furl) { (data, response, errors) in
                
                guard let Data = data else {print("Error");return}//declares data
                
                
                
                let decoderOne = JSONDecoder()//declares decoder
                if let forecast = try? decoderOne.decode(DForecast.self, from: Data) {//decodes to DForcast, "D" for daily
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {//delay to make sure decoding completes
                        self.dForecast = forecast
                    }
                    
                }
            }.resume()
        }
    }
}
class FetchData : ObservableObject{
    var locationManager = LocationManager.shared
    @Published var responses = Response()
    @Published var geocode = Recived()
    
    
    //this part is copy and pasted from another JSON file, I just changed the url.
    init(){
        let zip = getAddressFromLatLon(pdblLatitude: "\(locationManager.userLocation?.coordinate.latitude ?? 40)", withLongitude: "\(locationManager.userLocation?.coordinate.longitude ?? -74)")
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=c6a8b99c194944a5bf0162452211612&q=\(zip)&days=1&aqi=yes&alerts=no")!
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            
            guard let data = data else {return}
            
            
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Response.self, from: data) {
                DispatchQueue.main.async {
                    self.responses = response
                }
            }
            
            
        }.resume()
        
        //kinda just shows if the code is running. I'm leaving this in because I'm used to it
        //print(responses.current.temp_f)
    }
}
//structs for fetch data 2
struct Response: Codable{
    var current : Current = Current()
    var forecast: Forecast = Forecast()
    var location: Location = Location()
}

struct Location: Codable{
    var localtime : String = "2022-01-04 7:58"
}

struct Current: Codable{
    var temp_f : Double = 0
    var temp_c : Double = 0
    var condition : Condition?
}
struct Condition: Codable{
    var text : String
    var icon : String
    var code : Int
}

struct Forecast: Codable{
    var forecastday: [Forecastday] = [Forecastday()]
}

struct Forecastday: Codable{
    var day : Day = Day()
    var hour = Array(repeating: Hour(), count : 24)
}

struct Day: Codable{
    var maxtemp_f : Double = 0
    var mintemp_f : Double = 0
    var avgtemp_f : Double = 0
    var condition : Condition?
}

struct Hour: Codable{
    var time : String = "2022-01-04 00:00"
    var temp_f : Double = 0
    var condition : Condition?
    var wind_mph : Double = 0
    var feelslike_f : Double = 0
}
extension Hour: Identifiable{
    var id: String {return time}
}






//structs for geocoding
struct Recived : Codable{
    var result : Result = Result()
}
struct Result : Codable{
    var addressMatches : [AddressMatches] = [AddressMatches()]
}
struct AddressMatches : Codable{
    var coordinates : Coordinates = Coordinates()
}
struct Coordinates : Codable{
    var x : Float = 0
    var y : Float = 0
}
//end of geocoding structs
//structs for weather decoding
struct WResponse : Codable {
    var properties : Properties = Properties()
}
struct Properties: Codable{
    var forecast : String = "link"
    var forecastHourly : String = "link"
}
//end of weather structs
//structs for daily forecast decoding
struct DForecast : Codable {
    var properties : FDProperties = FDProperties()
    
}
struct FDProperties: Codable{
    var periods = Array(repeating: DPeriods(), count : 14)//intiilizes with the count it will have post decode
}
struct DPeriods : Codable{
    var number : Int = 0
    var name : String = ""
    var startTime : String = "2022-04-07T08:00:00-04:00"
    var endTime : String = "2022-04-07T08:00:00-04:00"
    var isDaytime : Bool?
    var temperature : Int = 0
    var temperatureUnit : String = ""
    var windSpeed : String = ""
    var windDirection : String = ""
    var icon : String = ""
    var shortForecast : String = ""
    var detailedForecast : String = ""
}
//end of daily forecast structs
//structs for hourly forecast decoding
struct HForecast : Codable {
    var properties : FHProperties = FHProperties()
    
}
struct FHProperties: Codable{
    var periods  = Array(repeating: HPeriods(), count : 156)//intiilizes with the count it will have post decode
}
struct HPeriods : Codable{
    var number : Int = 0
    var name : String = ""
    var startTime : String = "2022-04-07T08:00:00-04:00"
    var endTime : String = "2022-04-07T08:00:00-04:00"
    var isDaytime : Bool = true
    var temperature : Int = 0
    var temperatureUnit : String = ""
    var windSpeed : String = ""
    var windDirection : String = ""
    var icon : String = ""
    var shortForecast : String?
    var detailedForecast : String = ""
}
//end of daily forecast structs

func URlForm(_ address : String = "618 Schiller Ave", city : String = "Merion Station", state : String = "PA", zip : String = "19066") -> String{//function reads in an address and outputs a string url
    var finalURL  = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address="//static portion of the URL that holds the paramaters we dont need to change
    let URLEnd = "&benchmark=2020&format=json"//same as above but we stick it on the back
    finalURL = finalURL+address.replacingOccurrences(of: " ", with: "+")+"%2C+"+city.replacingOccurrences(of: " ", with: "+")+"%2C+"+state+"+"+zip+URLEnd//creates the URL replacing spaces with plus signs and adding other things in between that are nessecary for the link to function
    //print("In URLForm: "+finalURL)//prints for debug
    return finalURL//returns the url
}


//extreme overkill just to get data from longitude and lattitude
func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var postalC = "19066"

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
            
                postalC = pm[0].postalCode ?? "19066"
                print(postalC)
                if pm.count > 0 {
                    let pm = placemarks![0]
 

                    postalC = pm.postalCode ?? "19066"

                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


              }
        })
    //print(postalC)
    return postalC
        
    

    }
