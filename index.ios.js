/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NativeModules,
  NativeEventEmitter,
} from 'react-native';

export default class iosNativeModule extends Component {
	componentDidMount(){
		// console.log('Calendar Manager', NativeModules.CalendarManager)

		const calendarManagerEmitter = new NativeEventEmitter(NativeModules.CalendarManager)
		this.subscription = calendarManagerEmitter.addListener(
			'EventReminder',
			(reminder) => {
				console.log('EVENT')
				for( key in reminder){
					console.log(`${key}: ` + reminder[key])
				}
		        // console.log('name: ' + reminder.name)
		        // console.log('location: ' + reminder.location)
		        // console.log('date: ' + reminder.date)
				this.subscription.remove()
			}
		)

		// Call native method
		NativeModules.CalendarManager.addEvent('One', 'Two', 3, (o)=>{
			console.log('In Callback', o)
		})
	}

	componentWillUnmount(){
		this.subscription.remove()
	}

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('iosNativeModule', () => iosNativeModule);
