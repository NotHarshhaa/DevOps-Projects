import React from 'react'
import './BestRes.css'

function BestRest() {
  return (
    <div className='d-flex justify-content-center align-items-center mt-5 mb-5'>
        <div style={{width:"85%"}}>
            <h4 className='fw-bold'>Best Places to Eat Across Cities</h4>
            <div className='buttons-grp d-flex justify-content-between'>
                <button>Best Restaurent in Bangalore</button>
                <button>Best Restaurent in Pune</button>
                <button>Best Restaurent in Mumbai</button>
                <button>Best Restaurent in Delhi</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Best Restaurent in Hyderabad</button>
                <button>Best Restaurent in Kolkata</button>
                <button>Best Restaurent in Chennai</button>
                <button>Best Restaurent in Chandigarh</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Best Restaurent in Ahmadabad</button>
                <button>Best Restaurent in Jaipur</button>
                <button>Best Restaurent in Nagpur</button>
                <button>Show More <i className="fa-solid fa-angle-down"></i></button>
            </div>

            <h4 style={{marginTop:"80px"}} className='fw-bold'>Best Cuisines Near Me</h4>

            <div className='buttons-grp d-flex justify-content-between'>
                <button>Chinese Restaurant Near Me</button>
                <button>South Indian Restaurant Near Me</button>
                <button>Indian Restaurant Near Me</button>
                <button>Kerala Restaurant Near Me</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Korea Restaurant Near Me</button>
                <button>North India Restaurant Near Me</button>
                <button>Sea food Restaurant Near Me</button>
                <button>Bengali Restaurant Near Me</button>
            </div>

            <div className='buttons-grp d-flex justify-content-between mt-3'>
                <button>Punjabi Restaurant Near Me</button>
                <button>Italian Restaurant Near Me</button>
                <button>Andhra Restaurant Near Me</button>
                <button>Show More <i className="fa-solid fa-angle-down"></i></button>
            </div>

            <h4 style={{marginTop:"80px"}} className='fw-bold'>Explore Every Restaurants Near Me</h4>
            <div className='buttons-grps d-flex justify-content-between mt-3'>
                <button>Explore Restaurants Near Me</button>
                <button>Explore Top Rated Restaurants Near Me</button>
            </div>
        </div>
    </div>
  )
}

export default BestRest