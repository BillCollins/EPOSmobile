//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;

namespace EPOSmobile.Domain.Entities
{
    public partial class OrderItem
    {
        #region Primitive Properties
    
        public virtual int OrderItemID
        {
            get;
            set;
        }
    
        public virtual int Quantity
        {
            get { return _quantity; }
            set { _quantity = value; }
        }
        private int _quantity = 1;

        #endregion
        #region Navigation Properties
    
        public virtual Order Order
        {
            get { return _order; }
            set
            {
                if (!ReferenceEquals(_order, value))
                {
                    var previousValue = _order;
                    _order = value;
                    FixupOrder(previousValue);
                }
            }
        }
        private Order _order;
    
        public virtual Product Product
        {
            get { return _product; }
            set
            {
                if (!ReferenceEquals(_product, value))
                {
                    var previousValue = _product;
                    _product = value;
                    FixupProduct(previousValue);
                }
            }
        }
        private Product _product;

        #endregion
        #region Association Fixup
    
        private void FixupOrder(Order previousValue)
        {
            if (previousValue != null && previousValue.OrderItems.Contains(this))
            {
                previousValue.OrderItems.Remove(this);
            }
    
            if (Order != null)
            {
                if (!Order.OrderItems.Contains(this))
                {
                    Order.OrderItems.Add(this);
                }
            }
        }
    
        private void FixupProduct(Product previousValue)
        {
            if (previousValue != null && previousValue.OrderItems.Contains(this))
            {
                previousValue.OrderItems.Remove(this);
            }
    
            if (Product != null)
            {
                if (!Product.OrderItems.Contains(this))
                {
                    Product.OrderItems.Add(this);
                }
            }
        }

        #endregion
    }
}