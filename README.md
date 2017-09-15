# Recry

Recry is a basic phone tree designed to be easily accessible to the public and easily managed through a single Google Sheet backend.

The project is origianlly created by Christopher Guess and Elayne Saejung as part of the [Field Innovation Team](http://fieldinnovationteam.org/). The first deployment of the project was to support Rockport, Texas's public health information in response to Hurricane Harvey in August 2017.

## Use Cases

Recry is designed to serve a limited time frame to distribute information to isolated or technologically impaired populations. These could include areas with severe and widespread power outages, elderly populations with limited knowledge or desire to download specific apps, or impoverished areas with very low smartphone penetration.

Recry was origianlly created to supplement a lack of public health information in a region hit by a category 3 hurricane. The population was without power and dispropotionally elderly and poor. SMS and voice were chosen as the interface since everyone knows how to at least call a phone number and even most technologically disinclined people use SMS to communicate with family and friends. Outside of the US this will be even less of an issue.

The project is designed to be setup extremely quickly (under an hour) and within a limited budget (approx. $150US for a month of moderate use). The project utilizes [Twilio](https://www.twilio.com) to make and receive the SMS and voice calls. Where this can be deployed is only limited to Twilio's [active countries](https://support.twilio.com/hc/en-us/articles/223183068-Twilio-international-phone-number-availability-and-their-capabilities).

## Technology Stack

This all might seem like a bit of overkill, but it was created with the intention of ease of development and ease of deployment. Yes, I could have made it a bit lighter, but Ruby on Rails offers a complete stack I didn't have to cobble together myself and in a disaster those extra few hours can make a difference to the situation and your own mental health.

Required
------
* Ruby on Rails 5
* Postgres
* Twilio Account
* A Google account
* A host (I use Heroku, which just makes it easier and takes the pressure off me to manage a full server stack)

## Installation

This will use Heroku and assume you're using a Mac or Linux computer. Windows isn't very different but I don't have a machine to test with.

All of this is done from a "Terminal" window. If you don't know what that is please email me at cguess@gmail.com if it's an emergency.

It may seem like a lot, but most of this goes extremely quickly.

#### Deploy to Heroku
1. Clone repository
	```git clone https://www.github.com/cguess/recry && cd Recry```
1. Create a Heroku account at https://heroku.com
1. Install the Heroku CLI with instruction at https://devcenter.heroku.com/articles/heroku-cli
1. Create a new Heroku app ```heroku create```
1. Take note of the url that is created (it'll be slightly nonsensical and look something like ```https://thawing-inlet-61413.herokuapp.com/```)

#### Set Up Twilio Number
1. Create a Twilio account at https://www.twilio.com
1. When you've created an account it will ask you to create a number. Make sure to find one with a local area code to where you are deploying. This is important so users will trust the number.
1. You have to upgrade your account from the "trial" version. Otherwise all messages are prepended with a Twilio message and you can only send to preapproved nubmers.
1. In the Twilio console click "Phone Numbers" under "Recently Used Products"
1. Click on the nubmer you created
1. Scroll down to "Voice & Fax"
1. Under the "A Call Comes In" row type in the address we saved above when created the Heroku app, followed by "/voice". For instance ```https://thawing-inlet-61413.herokuapp.com/voice```
1. Make sure the drop down next to the text box says "HTTP POST"
1. Scroll down to "Messaging"
1. Under the "A Message Comes In" row type in the address we save above when creating the Heroku app, followed by "/questions". For instance ```https://thawing-inlet-61413.herokuapp.com/questions```
1. Make sure the drop down next to the text box says "HTTP GET"
1. Click "Save" at the bottom.
1. In the upper-right of the page, click your username, and then click "Account"
1. Under the "API Credentials" panel take note of the live "Account SID" and "Auth Token" (you'll have to click on the eye to be able to see it)

### Setup the Google Sheet
1. Go to https://docs.google.com/spreadsheets/u/0/
1. Create a new sheet, title it something meaningful for your and your team, take note of this name.

(Further Steps taken from https://www.twilio.com/blog/2017/03/google-spreadsheets-ruby.html)
1. Go to the [Google APIs Console](https://console.developers.google.com/?pli=1).
1. Create a new project.
1. Click Enable API. Search for and enable the Google Drive API.
1. Create credentials for a Web Server to access Application Data.
1. Name the service account and grant it a Project Role of Editor.
1. Download the JSON file.
1. Copy the JSON file to your recry directory and rename it to client_secret.json
1. Those are the credentials your application will need. They represent a user that can update spreadsheets on your behalf. We still need to give this user access to the spreadsheet we want to use though. Open client_secret.json and find and copy the client_email. In your spreadsheet click the “Share” button in the top right and paste the email, giving your service account edit rights.


### Finish Heroku Setup
1. Go to https://dashboard.heroku.com
1. Click on the new app you've just made
1. Go to the "Resources" tab
1. Under "Add-ons" type "postgres"
1. Click on the popup that says "Heroku Postgres"
1. Under "Plan Name" choose "Hobby Dev" (the free tier fills up very quickly)
1. Click "Provision"
1. Click on the "Settings" tab at the top of the dashboard
1. Click "Reveal Config Vars"
1. Add the following keys; TWILIO_ACCOUNT_AUTH_TOKEN, TWILIO_ACCOUNT_SID, TWILIO_PHONE_NUMBER, GOOGLE_SHEET_NAME, PROJECT_TITLE, along with their respective values we've been collecting (PROJECT_TITLE should be how you want the system to refer to itself, something like ```Rockport Publich Health Brochure System``` works well.)
1. Push the code to the Heroku git repository to deploy it. ```git push heroku master```

You should now be able to SMS or call the number above.

## Usage
All categories and answers are pulled automatically from the Google Sheet created above.

The cateories are the headers of each column. Each row below the top column is an answer.

Example:
```
|-------------------------------------------------------|
| Cateogry 1 |  Category 2  | Category 3  | Category 4  |
|-------------------------------------------------------|
| Response 1A|  Response 2A | Response 3A | Response 4A |
|-------------------------------------------------------|
| Response 1B|  Response 2B | Response 3B | Response 4B |
|-------------------------------------------------------|
| Response 1C|  Response 2C | Response 3C | Response 4C |
|-------------------------------------------------------|
| Response 1D|  Response 2D | Response 3D | Response 4D |
|-------------------------------------------------------|
```

##### A few notes
- All colons followed by a single space (": ") are replaced by "at the phone number" when being spoken. This is so that If something is typed in as ```Walmart: 212-555-5050``` it is read as "Walmart, at the phone number two one two five five five five zero five zero"

## Future improvements
- Caching of Google Sheets response on background thread so that it's checked every few minutes instead of every call. This should speed up responses pretty signifcantly.
- Multiple language support. This will probably be done by sheets in the Google Sheet, with each sheet being a different language. All of this would be dynamically pulled at runtime.
- Logging of calls and messages. Twilio does this already, but it'd be nice to have an internal report.
- UI or API for managing of logs.
- Automating this all would be nice, which may or may not be doable through APIs for Twilio, Google and Heroku.

## Contacts

- Christopher Guess
- @cguess
- cguess@gmail.com
- PGP: [6A6C 0C5C 331A 2F89 7BAF](https://keybase.io/cguess)


## Copyright

Copyright 2017 Christopher Guess

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.