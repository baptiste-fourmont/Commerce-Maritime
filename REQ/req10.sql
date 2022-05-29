--  Products that have been purchased or sold in the same quantities
SELECT
    DISTINCT Buy_Product.product_id
FROM
    Buy_Product FULL
    OUTER JOIN Sell_Product ON Buy_Product.id_etape = Sell_Product.id_etape
WHERE
    Buy_Product.quantity = Sell_Product.quantity
ORDER by
    Buy_Product.product_id;
