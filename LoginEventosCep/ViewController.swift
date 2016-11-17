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

    @IBOutlet weak var ScrollView: UIScrollView!
    var keywordUp:Bool = false
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func btnSave(_ sender: UIButton) {
        if self.txtName.text != "" && self.txtEmail.text != "" {
            //guardar los datos por medio del webservice
                        self.guardaDatos()
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
    //para guardar datos en bse de datos back
    func guardaDatos(){
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
            // asignar datos al JSON
            let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
            
            // definir request al JSON
            request .setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // asigna el HTTP request al metodo POST
            request.httpMethod="POST"
            
            // Agregue los datos de inicio de sesión del JSON
            request.httpBody = auth
            
            // Cree la tarea que enviará nuestra solicitud de inicio de sesión (de forma asíncrona)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                // hacer algo con el res`ponse HTTP
                print("Got response \(response) with error \(error)")
                print("Done.\(data)")
            })
            
            // Iniciar la tarea en un subproceso
            print("guardo datos")
            task.resume()
            
        } catch {
            // si hay error
            print("Error")
        }

    }
    func keyboardShow(notification: NSNotification) {
        if keywordUp {
            return
        }else{
            self.adjustscroll(zoom: true,notification: notification)
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        self.adjustscroll(zoom: false, notification: notification)
    }

    func adjustscroll(zoom:Bool,notification:NSNotification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let value = info.value(forKey: UIKeyboardFrameEndUserInfoKey)
        let frameKeyboard:CGRect = (value! as AnyObject).cgRectValue
        var size:CGSize = self.ScrollView.contentSize
        if zoom {
            size.height += frameKeyboard.size.height
        }else{
            size.height -= frameKeyboard.size.height
        }
        self.ScrollView.contentSize = size
        keywordUp = zoom
    }
    
    override func viewDidAppear(_ animated: Bool) {
          NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maxY:CGFloat = self.txtEmail.frame.maxY
        let ancho:CGFloat = UIScreen.main.bounds.width
        let newSize:CGSize = CGSize(width: ancho,height: maxY+30.0)
        self.ScrollView.contentSize = newSize    }

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

