
/* query to retrieve transactions for the last 50 days for Entity = 2125 */

select BusinessDay, ItemID, Sum(Quantity) from tbTransactionItem (nolock) where EntityID = 2125 and BusinessDay in
(select distinct top(50) BusinessDay from tbTransactionItem where EntityID = 2125 and BusinessDay < CONVERT(date, GETDATE()) order by BusinessDay desc)
group by BusinessDay, ItemId
order by BusinessDay, ItemId
