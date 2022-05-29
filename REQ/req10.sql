/*
    Les produits qui ont été acheté et vendu dans la même étape de même quantité
*/
SELECT DISTINCT Buy_Product.product_id
FROM Buy_Product
FULL OUTER JOIN Sell_Product
ON Buy_Product.id_etape = Sell_Product.id_etape AND Buy_Product.product_id = Sell_Product.product_id
WHERE Buy_Product.quantity = Sell_Product.quantity
ORDER by Buy_Product.product_id;