//
//  ViewController.swift
//  LoginEventosCep
//
//  Created by Mario Jimenez on 15/11/16.
//  Copyright © 2016 Mario Jimenez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var conexion:NSURLConnection?
    var datosRecibidos:NSMutableData?

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func btnSave(_ sender: UIButton) {
        if self.txtName.text != "" && self.txtEmail.text != "" {
            //guardar los datos por medio del webservice
            //******************************************
            let login = [
                         "clave" : 7777777777 ,
                         "nombre" :  self.txtName.text!,
                         "correo" : self.txtEmail.text!
                        ] as [String : Any]
            let strURL = "http://132.248.246.61:74/scepw.svc/create"
            let laurl = NSURL(string: strURL)!
            let request = NSMutableURLRequest(url: laurl as URL)

            let session = URLSession.shared
            
            
            do {
                // JSON all the things
                let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
                
                // Set the request content type to JSON
                request .setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // The magic...set the HTTP request method to POST
                request.httpMethod="POST"
                
                // Add the JSON serialized login data to the body
                request.httpBody = auth
                
                // Create the task that will send our login request (asynchronously)
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    // Do something with the HTTP response
                    print("Got response \(response) with error \(error)")
                    print("Done.")
                })
                
                // Start the task on a background thread
                print("guardo datos")
                task.resume()
                
            } catch {
                // Handle your errors folks...
                print("Error")
            }
            
            //******************************************
            // pasar al siguiente activity
            self.performSegue(withIdentifier: "login", sender: self)
        }
        else {
            let ac:UIAlertController = UIAlertController(title: "Error", message: "Todos los campos son requeridos", preferredStyle: .alert)
            let bac = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(bac)
            self.present(ac, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        print ("No se puede acceder al WS Estados: Error del server")
    }
    
    func conectionResponse (notif: NSNotification){
        //self.elSol = (notif.userInfo!["WMRegresaMunicipios"] as! NSArray)
        //para quitar la notificacion dejar de recibnir todas , pero eso es peligroso por lo del teclado
        
     }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: URLResponse) { // Ya se logrò la conexion, preparando para recibir datos
        self.datosRecibidos?.length = 0
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) { // Se recibiò un paquete de datos. guardarlo con los demàs
        self.datosRecibidos?.append(data as Data)
    }
    func connectionDidFinishLoading(connection: NSURLConnection){
        do {
       
        }
        catch {
            print ("Error al recibir webservice")
        }
    }


}

