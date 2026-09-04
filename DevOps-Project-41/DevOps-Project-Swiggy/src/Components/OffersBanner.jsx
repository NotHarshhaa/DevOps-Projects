import React from 'react'
import './OfferBanner.css'
import banner2 from'../Photos/Banner2.png'
import banner1 from'../Photos/Banner1.png'
import banner3 from'../Photos/Banner3.png'
import banner4 from'../Photos/Banner4.png'


function OffersBanner() {
    return (
        <div className=' d-flex justify-content-center align-items-center mt-5 flex-column'>
            <div className='w-75 '>
                <h4 className='fw-bolder'>Best offers for you</h4>
                <div id='banner-img' className='d-flex align-items-center ' style={{overflowY:"scroll",gap:"20px"}}>
                    <img width={'450px'} src={banner2} alt="Offer" />
                    <img width={'450px'} src={banner1} alt="Offer" />
                    <img width={'450px'} src={banner3} alt="Offer" />
                    <img width={'450px'} src={banner4} alt="Offer" />
                </div>
            </div>

            <div className='w-75 mt-5'>
                
                <h4 className='fw-bolder'>What's on your mind Today?</h4>
                <div className='d-flex align-items-center' style={{overflowY:"scroll",gap:"19px"}}>
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/rng/md/carousel/production/e20c602ba8ed5d8ec2204e7a7b19d9f6" alt="Pothichoru" />

                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/Biryani_2.png" alt="Biriyani" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029845/PC_Creative%20refresh/3D_bau/banners_new/Burger.png" alt="Burger" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029856/PC_Creative%20refresh/3D_bau/banners_new/Pizza.png" alt="Pizza" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667626/PC_Creative%20refresh/South_Indian_4.png" alt="South Indian" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029848/PC_Creative%20refresh/3D_bau/banners_new/Chinese.png" alt="Chinease" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667625/PC_Creative%20refresh/North_Indian_4.png" alt="North Indian" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029859/PC_Creative%20refresh/3D_bau/banners_new/Shawarma.png" alt="Shawarma" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029858/PC_Creative%20refresh/3D_bau/banners_new/Rolls.png" alt="Rolls" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1675667630/PC_Creative%20refresh/Desserts_2.png" alt="Deserts" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029858/PC_Creative%20refresh/3D_bau/banners_new/Shakes.png" alt="Shakes" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029858/PC_Creative%20refresh/3D_bau/banners_new/Pure_Veg.png" alt="Pure Veg" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029850/PC_Creative%20refresh/3D_bau/banners_new/Dosa.png" alt="Dosa" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029845/PC_Creative%20refresh/3D_bau/banners_new/Cakes.png" alt="Cakes" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029853/PC_Creative%20refresh/3D_bau/banners_new/Paratha.png" alt="Paratha" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029854/PC_Creative%20refresh/3D_bau/banners_new/Pasta.png" alt="Pasta" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029853/PC_Creative%20refresh/3D_bau/banners_new/Kebabs.png" alt="Kebabs" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029846/PC_Creative%20refresh/3D_bau/banners_new/Idli.png" alt="Idli" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/v1674029851/PC_Creative%20refresh/3D_bau/banners_new/Ice_Creams.png" alt="Ice Creams" />
                    <img className='img-fluid' width={'140px'} src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_288,h_360/rng/md/carousel/production/cbb85a3c1684891105294d11f8359996" alt="Tea" />

                   
                    
                </div>
                <hr />
            </div>
        </div>
    )
}

export default OffersBanner
