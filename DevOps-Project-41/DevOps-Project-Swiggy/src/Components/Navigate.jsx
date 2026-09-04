import React from 'react'
import { Col, Row } from 'react-bootstrap'
import './Navigate.css'

function Navigate() {
    return (
        <div>
            <Row className='w-100 pt-3 shadow pb-2'>
                <Col >
                    <div id='Nav-logo' style={{gap:"30px"}} className='d-flex justify-content-center align-items-center'>
                        <img width={'55px'} src="https://www.theknowhowlib.com/wp-content/uploads/2020/05/Swiggy-2.png" alt="lolll" />
                        <p style={{fontSize:"13px"}} className='mt-3'><span className='fw-bold text-decoration-underline'>Amalapuram</span> 10-34, Shankar-matam Veedhi, Near Godavari Delta...</p>
                        <i style={{color:"#e78838"}} className="fa-solid fa-angle-down"></i>
                        </div>
                </Col>
                <Col>
                        <div id='Nav-icons' className='d-flex justify-content-between align-items-center w-75 mt-3'>
                            <p><i className="fa-solid fa-magnifying-glass"> </i> Search</p>
                            <p><i className="fa-solid fa-percent"></i> Offers <sup style={{color:"#fda502"}}>New</sup> </p>
                            <p><i className="fa-solid fa-bowl-food"></i> Help</p>
                            <p><i className="fa-regular fa-user"></i> Profile</p>
                            <p><i className="fa-solid fa-cart-shopping"></i> Cart</p>
                        </div>
                </Col>
            </Row>
        </div>
    )
}

export default Navigate