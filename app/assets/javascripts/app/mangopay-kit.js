console.log("sprockets")

var mangoPay = {
  cardRegistration: {
    init: function (cardRegisterData) {
      this._cardRegisterData = cardRegisterData;
    },

    registerCard: function (cardData, successCallback, errorCallback) {
      // Validate card data
      // var isCardValid = mangoPay.cardRegistration._validateCardData(cardData);
      // if (isCardValid !== true) {
      //   errorCallback(isCardValid);
      //   return;
      // };

      // Try to register card in two steps: get Payline token and then finish card registration with MangoPay API
      mangoPay.cardRegistration._tokenizeCard(
        cardData,
        mangoPay.cardRegistration._finishRegistration,
        successCallback,
        errorCallback
      );
    }
  }
}
