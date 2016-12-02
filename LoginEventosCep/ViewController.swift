//
//  ViewController.swift
//  LoginEventosCep
//
//  Created by Mario Jimenez on 15/11/16.
//  Copyright © 2016 Mario Jimenez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import CoreData
class ViewController: UIViewController,FBSDKLoginButtonDelegate
    {
  
    
    var conexion:NSURLConnection?
    var datosRecibidos:NSMutableData?
    
    let loginbutton: FBSDKLoginButton = {
    let button = FBSDKLoginButton()
    button.readPermissions=["email"]
        return button
    }()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    var keywordUp:Bool = false
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func btnSave(_ sender: UIButton)
    {
        if self.txtName.text != "" && self.txtEmail.text != ""
        {
            //guardar los datos por medio del webservice
                        self.guardaDatos()
            // pasar al siguiente activity
            performSegueWithIdentifier("login", sender: nil)
        }
        else{
            let ac:UIAlertController = UIAlertController(title: "Error", message: "Todos los campos son requeridos", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(ac, animated: true, completion: nil)
            /*let bac = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(bac)
            self.present(ac, animated: true, completion: nil)*/
        }
        
    }
    //para guardar datos en bse de datos back
    func guardaDatos()
    {
        let login = [
            "clave" : 7777777777 ,
            "nombre" :  self.txtName.text!,
            "correo" : self.txtEmail.text!
            ] as [String : Any]
        let strURL = "http://132.248.246.61:74/scepw.svc/create"
        let laurl = NSURL(string: strURL)!
        let request = NSMutableURLRequest(URL: laurl as NSURL)
        /*
        let session = URLSession.shared
        
        
        do
        {
            // asignar datos al JSON
            let auth = try JSONSerialization.data(withJSONObject: login, options: .prettyPrinted)
            
            // definir request al JSON
            request .setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // asigna el HTTP request al metodo POST
            request.httpMethod="POST"
            
            // Agregue los datos de inicio de sesión del JSON
            request.httpBody = auth
            
            // Cree la tarea que enviará nuestra solicitud de inicio de sesión (de forma asíncrona)
            let task = session.dataTask(with: request as URLRequest, completionHandler:
                { (data, response, error) -> Void in
                    // hacer algo con el res`ponse HTTP
                    print("Got response \(response) with error \(error)")
                    print("Done.\(data)")
                })
            
            // Iniciar la tarea en un subproceso
            print("guardo datos")
            task.resume()
            
        } catch
        {
            // si hay error
            print("Error")
        }*/
    }
    
    func keyboardShow(notification: NSNotification)
    {
        if keywordUp
        {
            return
        }
        else
        {
            self.adjustscroll(true,notification: notification)
        }
    }
    
    func keyboardHide(notification: NSNotification)
    {
        self.adjustscroll(false, notification: notification)
    }

    func adjustscroll(zoom:Bool,notification:NSNotification)
    {
       /* let info:NSDictionary = notification.userInfo! as NSDictionary
        let value = info.allKeysForObject(UIKeyboardFrameEndUserInfoKey)
        let frameKeyboard:CGRect = (value as AnyObject).cgRectValue
        var size:CGSize = self.ScrollView.contentSize
        if zoom
        {
            size.height += frameKeyboard.size.height
        }
        else
        {
            size.height -= frameKeyboard.size.height
        }
        self.ScrollView.contentSize = size
        keywordUp = zoom*/
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }

    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let maxY:CGFloat = self.txtEmail.frame.maxY
        let ancho:CGFloat = screenSize.width//UIScreen.main.bounds.width
        let newSize:CGSize = CGSize(width: ancho,height: maxY+30.0)
        self.ScrollView.contentSize = newSize
        loginbutton.center=view.center
        loginbutton.delegate = self
            if let token = FBSDKAccessToken.currentAccessToken() {
            regresaPerfil()
            }
        }
    
    func regresaPerfil(){
    print("perfil fecebook")
        let parameters = ["fields": "email,first_name,last_name,picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            if error != nil {
            print(error)
                return
            }
            if let email = result["email"] as? String {
            print (email)
            }
            print(result)
            
            if let picture = result["picture"] as? NSDictionary, data=picture["data"] as? NSDictionary, url=data["utl"] as? String {
                print(url)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
        }
    
    func logoutFB()
    {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
         regresaPerfil()
    }
    
    /*!
     @abstract Sent to the delegate when the button was used to logout.
     @param loginButton The button that was clicked.
     */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        print ("No se puede acceder al WS usuarios: Error del server")
    }
    
    func conectionResponse (notif: NSNotification){
        //self.elSol = (notif.userInfo!["WMRegresaMunicipios"] as! NSArray)
        //para quitar la notificacion dejar de recibnir todas , pero eso es peligroso por lo del teclado
        
     }
    
}

