import React, {useEffect, useState} from 'react';
import {View, Text, Image, Button} from 'react-native';
import {useApplicationContext} from "./AuthContext";
import axios from "axios";
import {useDispatch, useSelector} from "react-redux";
import {loadDish} from "../slices/Dish";
import {fetchOrderById, loadDetailledOrders, loadOrders} from "../slices/Orders";
import {loadDishes} from "../slices/Dishes";
import {addDishesToBasket, removeDishesFromBasket} from "../slices/Basket";
import Icon from "react-native-vector-icons/FontAwesome";



export default function Order({ orderId }) {

    const dispatch = useDispatch();

    useEffect(() => {
        dispatch(loadDishes())
        dispatch(loadDetailledOrders())
    }  , []);
    const dishes = useSelector(state => state.dishes.value)

    const order = useSelector(state => state.orders.orderDetails.find(order => order.id === orderId))

    return (
        <View className="my-3 shadow-xl p-5 bg-white">
            <Text className="text-2xl font-bold">Commande n°{orderId}</Text>
            <Text className="text-xl">Passée le { new Date(order?.date).toLocaleDateString() }</Text>
            <Text className="text-xl">Adresse de livraison : {order?.address}</Text>
            <Text className="text-xl text-[#713235] font-bold mb-5">Prix total : {order?.totalPrice.toFixed(2)}€</Text>

            {order?.orderContent && Object.entries(order?.orderContent).map(([key, quantity]) =>  {
                const dish = dishes.find((e) => e.id === parseInt(key));
                console.log(dishes)
                return(
                    // <View className="my-3 shadow-xl p-5 bg-white">
                    //     <Image
                    //         className="w-20 h-20"
                    //         source={{ uri: dish?.image }}
                    //     />
                    //     <View>
                    //         <Text>{dish?.name}</Text>
                    //         <Text>{dish?.price}€</Text>
                    //         <Text>quantity :{quantity}</Text>
                    //     </View>
                    // </View>


                    <View className="flex flex-col md:flex-row justify-start bg-white mb-3 shadow-xl">
                        <Image
                            source={{ uri: dish?.image }}
                            className="w-full h-[100px] md:h-full md:w-[200px]"
                        />
                        <View className="m-3 flex-1">
                            <View className="flex flex-row items-center justify-start w-full mb-1">
                                <Text className="text-2xl">{dish?.name}</Text>
                                <Text className="text-xl text-[#713235] font-bold ml-10">{dish?.price.toFixed(2)}€</Text>
                            </View>



                            { quantity > 1 &&
                                <View className="flex flex-row items-center mb-1">
                                    <Text className="text-xl text-[#713235]">Quantité : {quantity}</Text>
                                    <Text className="text-xl ml-10">Total : { dish?.price * quantity }€</Text>
                                </View>
                            }
                        </View>
                    </View>
                )
            })}
        </View>
    );
}