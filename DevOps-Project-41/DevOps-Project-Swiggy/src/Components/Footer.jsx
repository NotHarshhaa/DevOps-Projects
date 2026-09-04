import React from 'react'
import logo from '../Photos/Logo.png'

function Footer() {
  return (
    <div className='d-flex flex-column justify-content-center align-items-center w-100'>
       <div  style={{backgroundColor:"#f1f0f4"}} className='w-100 d-flex justify-content-center align-items-center'>
            <div className='w-75 d-flex justify-content-center align-items-center pt-3 pb-3'>
                <h3 style={{letterSpacing:"-.5px",fontWeight:900,color:"#41444a"}}>For better experience,download <br /> the Swiggy app now</h3>
                <img className='img-fluid' width={'180px'} style={{height:"60px",marginLeft:"90px",marginRight:"30px"}} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto/portal/m/play_store.png" alt="" />
                <img width={'180px'} style={{height:"60px"}} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto/portal/m/app_store.png" alt="" />
            </div>
       </div>
       <div style={{backgroundColor:"#02050c"}} className='d-flex justify-content-center align-tems-center w-100'>
            <div className='w-75 d-flex justify-content-around  pt-5 pb-5'>
                <div>
                    <div className='d-flex align-items-center'><img width={'30px'} src={logo} alt="Logo" />
                    <h3 style={{color:"white"}} className='fw-bolder mt-1 ms-2'>Swiggy</h3></div>
                    <p style={{color:"white"}}>© 2023 Bundl Technologies Pvt. Ltd</p>
                </div>
                <div style={{color:"#9e9e9e"}}>
                    <h5 style={{color:"white"}}>Company</h5>
                    <p>About</p>
                    <p>Careers</p>
                    <p>Team</p>
                    <p>Swiggy One</p>
                    <p>Swiggy Instamart</p>
                    <p>Swiggy Genie</p>
                </div>
                <div style={{color:"#9e9e9e"}}>
                    <h5 style={{color:"white"}}>Contact us</h5>
                    <p>Help & Support</p>
                    <p>Partner with us</p>
                    <p>Ride with us</p>
                    <h5 style={{color:"white"}} className='mt-5'>Legal</h5>
                    <p>Terms & Conditions</p>
                    <p>Cokkie Policy</p>
                    <p>Privacy Policy</p>
                </div>
                <div style={{color:"#9e9e9e"}}>
                    <h5 style={{color:"white"}}>We deliver to:</h5>
                    <p>Bangalore</p>
                    <p>Gurgaon</p>
                    <p>Hyderabad</p>
                    <p>Delhi</p>
                    <p>Mumbai</p>
                    <p>Pune </p>
                    <button style={{padding:"10px",background:"transparent",color:"#9e9e9e",border:"1px solid rgba(196, 198, 202, 0.1)",borderRadius:"20px"}}>589 cities    <i className="ms-5 fa-solid fa-angle-down"></i></button>
                </div>
            </div>
       </div>
        
    </div>
  )
}

export default Footer