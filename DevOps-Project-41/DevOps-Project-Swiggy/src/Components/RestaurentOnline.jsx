import React from 'react'
import './RestaurentOnline.css'

function RestaurentOnline() {
    return (
        <div className='d-flex justify-content-center align-items-center mt-5'>
            <div className='w-75'>
                <h4 className='fw-bold'>Restaurants with online food delivery in Kochi</h4>
                <div style={{ gap: "1" }} className='buttonsoffiltering'>
                    <button>filter<i class="fa-solid fa-gears"></i></button>
                    <button>Sort by<i class="fa-solid fa-angle-down"></i></button>
                    <button>Fast Delivery</button>
                    <button>New On Swiggy</button>
                    <button>Rate 4.0+</button>
                    <button>Pure Veg</button>
                    <button>Offers</button>
                    <button>Rs.300 - Rs.600</button>
                    <button>Less Than Rs.300</button>
                </div>

                <div id='Card-section'>
                    <div className='d-flex justify-content-between mt-4'>
                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/0b3356a88b6fc5966c452c4c9b1b5e4a)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >40% OFF UPTO ₹80</h4></div>
                        </div>
                        <h5 className='mt-3'>The Good Bowl</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4
                        <p style={{fontWeight:"300"}}>Biriyani, North Indian, Pastas, Punjabi<br />Chittethukara</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/4a3b48488e3aa9bda13efd8cfcd95284)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >60% OFF UPTO ₹120</h4></div>
                        </div>
                        <h5 className='mt-3'>Sweet Truth-Cake and...</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>3.9
                        <p style={{fontWeight:"300"}}>Snacks, Bakery, Dessert, Beverages<br />Chittethukara</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/fx2mgrbp4ifryi76pgef)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >25% OFF UPTO ₹125</h4></div>
                        </div>
                        <h5 className='mt-3'>Frozen Bottle - Milkshakes,...</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4.1
                        <p style={{fontWeight:"300"}}>Deserts, Beverages, IceCream,...<br />Ernakulam</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/af33b81798b11deba338e94b7585d348)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >50% OFF UPTO ₹100</h4></div>
                        </div>
                        <h5 className='mt-3'>Faasos - Wrap & Rolls</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>3.7
                        <p style={{fontWeight:"300"}}>Kebabs, Fast Food, Snacks, North...<br />Chittethukara</p>
                    </div>
                    </div>

                    <div className='d-flex justify-content-between'>
                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/1ace5fa65eff3e1223feb696c956b38b)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >50% OFF UPTO ₹100</h4></div>
                        </div>
                        <h5 className='mt-3'>Subway</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>3.9
                        <p style={{fontWeight:"300"}}>Healthy Food, Salad, Snacks,...<br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/hqskgt9wjjgqkj74coyw)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' ></h4></div>
                        </div>
                        <h5 className='mt-3'>The Burger Junction</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4.5
                        <p style={{fontWeight:"300"}}>American, Beverages<br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/56c9ab92bd79745fd152a30fa2525426)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' ></h4></div>
                        </div>
                        <h5 className='mt-3'>KFC</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star">20% OFF UPTO ₹50</i>4.1
                        <p style={{fontWeight:"300"}}>American, Burgers, Biriyani, Snacks,...<br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/ly5rzyg6tzwu4idmy4i1)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' ></h4>10% OFF UPTO ₹40</div>
                        </div>
                        <h5 className='mt-3'>Amma's Pastries</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>3.9
                        <p style={{fontWeight:"300"}}>Desserts, Bakery<br />Kakkanad</p>
                    </div>
                    </div>

                    <div className='d-flex justify-content-between'>
                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/xxi1rb25fxm3le88weuo)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >20% OFF UPTO ₹50</h4></div>
                        </div>
                        <h5 className='mt-3'>Thaal Kitchen</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>3.9
                        <p style={{fontWeight:"300"}}>Kerala, Arabian<br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/jbdpvb8bmzjirqmg44w3)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >30% OFF UPTO ₹75</h4></div>
                        </div>
                        <h5 className='mt-3'>Burger Spot</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4.5
                        <p style={{fontWeight:"300"}}><br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/ee5f8e06b300efc07c9fe3f4df40dfc4)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' ></h4></div>
                        </div>
                        <h5 className='mt-3'>Mc Donald's</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4.3
                        <p style={{fontWeight:"300"}}>Burger, Beverages, Cafe, Desserts<br />Kakkanad</p>
                    </div>

                    <div className='Online-card'>
                        <div style={{
                            backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/zchpuqit7k4pdndgse4t)`
                        }} className='Online-Card-img '>
                            <div className='Online-color'><h4 className='fw-bolder' >30% OFF UPTO ₹75</h4></div>
                        </div>
                        <h5 className='mt-3'>Palaaram</h5>
                        <i style={{color:"#20963a"}} className="fa-solid fa-star"></i>4.2
                        <p style={{fontWeight:"300"}}>Kerala, Biriyani, North Indian, Arabian,...<br />Kakkanad</p>
                    </div>
                    </div>

                    <div className='d-flex justify-content-between'>
                        <div className='Online-card'>
                            <div style={{
                                backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/k2why61tsxk9sh0sl68d)`
                            }} className='Online-Card-img'>
                                <div className='Online-color'><h4 className='fw-bolder' >10% OFF UPTO ₹40</h4></div>
                            </div>
                            <h5 className='mt-3'>Alakapuri</h5>
                            <i style={{ color: "#20963a" }} className="fa-solid fa-star"></i>4.4
                            <p style={{ fontWeight: "300" }}>South indian, Kerala, North Indian <br />Kakkanad</p>
                        </div>

                        <div className='Online-card'>
                            <div style={{
                                backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/jys7zsopl1sjy2wwxadd)`
                            }} className='Online-Card-img '>
                                <div className='Online-color'><h4 className='fw-bolder' >FREE ITEM</h4></div>
                            </div>
                            <h5 className='mt-3'>Galaxy Family Restaurent</h5>
                            <i style={{ color: "#20963a" }} className="fa-solid fa-star"></i>4.4
                            <p style={{ fontWeight: "300" }}>kerala, South indian, Chinease, North.... <br />Kakkanad</p>
                        </div>

                        <div className='Online-card'>
                            <div style={{
                                backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/xejp6fugbtzu08vpfqmu)`
                            }} className='Online-Card-img '>
                                <div className='Online-color'><h4 className='fw-bolder' ></h4></div>
                            </div>
                            <h5 className='mt-3'>Aryaas</h5>
                            <i style={{ color: "#20963a" }} className="fa-solid fa-star"></i>4.4
                            <p style={{ fontWeight: "300" }}>South indian, North Indian, Chinease <br />Kakkanad</p>
                        </div>

                        <div className='Online-card'>
                            <div style={{
                                backgroundImage: `url(https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_660/56b7222d3239a954d09b42c05347debf)`
                            }} className='Online-Card-img '>
                                <div className='Online-color'><h4 className='fw-bolder' >10% OFF UPTO ₹40</h4></div>
                            </div>
                            <h5 className='mt-3'>Al Sheba Kuzhimandhi</h5>
                            <i style={{ color: "#20963a" }} className="fa-solid fa-star"></i>4.1
                            <p style={{ fontWeight: "300" }}>Arabian, Beverages <br />Kakkanad</p>
                        </div>
                    </div>
                </div>
                <hr />
            </div>
        </div>
    )
}

export default RestaurentOnline