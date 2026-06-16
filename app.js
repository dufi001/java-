function triggerMobileMoneyModal() {
    let qty = parseInt(document.getElementById('order-quantity').value);
    let totalCost = qty * currentPrice;
    let operator = document.getElementById('payment-operator').value;
    
    let ussdCode = (operator === "MTN") ? "*182*1*1*0793197955#" : "*182*1*1*0726275105#";

    const modal = document.createElement("div");
    modal.className = "modal-overlay";
    modal.id = "paymentModal";
    modal.style = "position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; justify-content: center; align-items: center; z-index: 5000;";
    
    // Updated HTML layout structure matching your exact modal UI design
    modal.innerHTML = `
        <div class="phone-container" style="width: 340px; background: #333333; border-radius: 16px; padding: 25px; color: white; text-align: center; font-family: sans-serif; box-shadow: 0 10px 25px rgba(0,0,0,0.3);">
            <div style="background: #f1c40f; color: black; padding: 12px; font-weight: bold; font-size: 1.2rem; border-radius: 6px; text-transform: uppercase; margin-bottom: 20px;">
                ${operator} MOMO PUSH PAY
            </div>
            <p style="font-size: 1.05rem; margin-bottom: 10px;">Authorize batch release of ${qty} units of Fresh Wholesale ${currentProduct}</p>
            <p style="font-size: 1.4rem; color: #f1c40f; font-weight: bold; margin-bottom: 20px;">Amount: ${totalCost} RWF</p>
            
            <div style="display: flex; flex-direction: column; gap: 12px;">
                <input type="text" id="modalMobileNo" placeholder="Enter Physical Mobile No." 
                       style="width: 100%; padding: 12px; border-radius: 6px; border: none; background: #444; color: white; box-sizing: border-box;">
                
                <input type="password" id="modalWalletPin" maxlength="5" placeholder="Enter Secret Wallet PIN" 
                       style="width: 100%; padding: 12px; border-radius: 6px; border: none; background: #444; color: white; box-sizing: border-box; text-align: center; letter-spacing: 3px;">
            </div>

            <div style="display: flex; gap: 15px; margin-top: 25px;">
                <button onclick="document.getElementById('paymentModal').remove()" 
                        style="flex: 1; background: #e74c3c; color: white; padding: 12px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">
                    CANCEL
                </button>
                <button onclick="processPrototypePayment('${ussdCode}')" 
                        style="flex: 1; background: #2ecc71; color: white; padding: 12px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">
                    APPROVE
                </button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

function processPrototypePayment(ussdCode) {
    const phone = document.getElementById("modalMobileNo").value;
    const pin = document.getElementById("modalWalletPin").value;

    if (phone.trim() === "" || pin.length < 4) {
        alert("Please provide a valid destination phone number and secure wallet pin key.");
        return;
    }

    // Process back-end inventory stock removal updates
    fetch("OrderServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `productName=${currentProduct}&quantity=${document.getElementById('order-quantity').value}`
    })
    .then(res => res.text())
    .then(status => {
        if (status === "payment_verified") {
            document.getElementById("paymentModal").remove();
            
            // Format character '#' to '%23' for browser environment safety
            let encodedUssd = ussdCode.replace("#", "%23");
            window.location.href = "tel:" + encodedUssd;

            alert("🎉 Simulated authorization complete! Stock deducted inside database repository.");
            window.location.reload();
        }
    });
}