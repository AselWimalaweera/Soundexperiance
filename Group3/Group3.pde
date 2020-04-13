import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import nl.tue.id.oocsi.*;

// ******************************************************
// This example requires a running OOCSI server!
//
// How to do that? Check: Examples > Tools > LocalServer
//
// More information how to run an OOCSI server
// can be found here: https://iddi.github.io/oocsi/)
// ******************************************************

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave1;
Oscil       wave2;
AudioSample chime;
AudioSample canopen;
AudioSample chopcourgette;
AudioSample clock;
AudioSample fireplace;
AudioSample italian;
AudioSample mexican;
AudioSample minceherbs;
AudioSample pepper;
AudioSample reduceheat;
AudioSample stomach;
AudioSample turnonheat;
AudioSample ambient1;
AudioSample ambient2;

void setup() {
  size(200, 200);
  noStroke();

  // connect to OOCSI server
  OOCSI oocsi = new OOCSI(this, "group3conn", "oocsi.id.tue.nl");

  // subscribe to DBSU10 channel
  oocsi.subscribe("dbsu10_home_environment");
  oocsi.subscribe("recipeChannel");
  oocsi.subscribe("DoorAndHallway");
  oocsi.subscribe("cuttingSpeedChannel");
  oocsi.subscribe("boardWeightChannel");
  oocsi.subscribe("Swater_Channel");

  minim = new Minim(this);

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();

  // create a sine wave Oscil, set to 220 Hz, at 0.5 amplitude
  //wave1 = new Oscil( 220, 0.2f, Waves.SINE );
  // patch the Oscil to the output
  //wave1.patch( out );

  // this audio player can play sound files in mp3 or wav format
  // be careful with the size of wav files, they might be BIG
  chime = minim.loadSample("chime.wav");
  canopen = minim.loadSample("canopen.wav");
  chopcourgette = minim.loadSample("chopcourgette.wav");
  clock = minim.loadSample("clock.wav");
  fireplace = minim.loadSample("fireplace.wav");
  italian = minim.loadSample("italian.wav");
  mexican = minim.loadSample("mexican.wav");
  minceherbs = minim.loadSample("minceherbs.wav");
  pepper = minim.loadSample("pepper.wav");
  reduceheat = minim.loadSample("reduceheat.wav");
  stomach = minim.loadSample("stomach.wav");
  turnonheat = minim.loadSample("turnonheat.wav");
  ambient1 = minim.loadSample("ambient1.wav");
  ambient2 = minim.loadSample("ambient2.wav");
}

void draw() {
}

void handleOOCSIEvent(OOCSIEvent event) {

   boolean sound_playing = false;
   
   //Play Ambient sounds   
   if (event.has("temperatureC")){
      int TemperatureC = event.getInt("TemperatureC", 0);
      if ( TemperatureC >= 20) {
          ambient1.trigger();
      } 
      if ( TemperatureC < 20) {
          ambient2.trigger();
      } 
   }
   
   //doorknob temp
   if (event.has("temperatureC")){
      int TemperatureC = event.getInt("TemperatureC", 0);
      if ( TemperatureC >= 20) {
          canopen.trigger();
      } 
      if ( TemperatureC < 20) {
          fireplace.trigger();
      } 
   }

   // Chime whenever recipe changes step
   if (event.has("step")){

     chime.trigger();
   }

   // Alarm clock
   if (event.has("SOUND")){
     if (event.getInt("SOUND", 0) > 0){

       clock.trigger();
     }
   }

  // Herb weight
  if (event.has("weight")){
      int Weight_herbs = event.getInt("weight", 0);

      if (Weight_herbs >= 30) {
        pepper.trigger();
      } 
  }

  // Flowerpot 
  if (event.has("Flowerpot")){
    String pot_color = event.getString("Flowerpot");

    if (pot_color.equals("RED")){

      while (sound_playing == true) {}
      sound_playing = true;
      mexican.trigger();
      delay(2000);
      mexican.stop();
      sound_playing = false;
      
    } else if (pot_color.equals("BLUE")) {

      while (sound_playing == true) {}
      sound_playing = true;
      italian.trigger();
      delay(2000);
      italian.stop();
      sound_playing = false;

    }

  }


  // Cutting of stuff
  if (event.has("frequency")){
    int freq = event.getInt("frequency", 0);

    switch (freq){
    case 1:
      chopcourgette.trigger();
      break;
    case 2:
      minceherbs.trigger();
      break;
    }
  }

 



//for frequency of our cutting borad(Chime,chopcourgette,minceherbs,reduceheat,turnonheat)

/*



// Let the sinoid in the background differ when frequency of chopping changes
  if (event.has("frequency")) {
    float amp = map(event.getInt("frequency", 0), 0, 220, 0, 1);
    wave1.setAmplitude(amp);
  }
  
 // product_data5 will become switch of recipe step
  if (event.has("product_data1")) {
    chime.trigger();
  }
 
   //If frequency of knife differs when to sound when veggies are cut 
   if (event.has("frequency")) {
   ()
    float amp = map(event.getInt("frequency", 0), 0, 400, 0, 1);
    wave1.setAmplitude(amp);
  }
   if (event.has("product_data3")) {
    chopcourgette.trigger();
  }
  
  //Frequcncey of the cutting board 
  if (event.has("frequency")) {
    float amp = map(event.getInt("frequency", 0), 0, 220, 0, 1);
    wave1.setAmplitude(amp);
  }
   if (event.has("product_data8")) {
    minceherbs.trigger();
  }
  
  // weight data to measure how much herbs is needed
  if (event.has("weight")) {
    float amp = map(event.getInt("weight", 0), 0, 220, 0, 1);
    wave1.setAmplitude(amp);
  }
 
  //sound of the intencity if the fire 
  if (event.has("frequency")) {
    float amp = map(event.getInt("frequency", 0), 0, 220, 0, 1);
    wave1.setAmplitude(amp);
  }
  if (event.has("product_data10")) {
    reduceheat.trigger();
  }
  
  //sound of the intencity if the fire 
 if (event.has("frequency")) {
    float amp = map(event.getInt("frequency", 0), 0, 220, 0, 1);
    wave1.setAmplitude(amp);
  }
   if (event.has("product_data12")) {
    turnonheat.trigger();
   }
  */
}
