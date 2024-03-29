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
    public partial class Product
    {
        #region Primitive Properties
    
        public virtual int ProductID
        {
            get;
            set;
        }
    
        public virtual string Name
        {
            get;
            set;
        }
    
        public virtual string Description
        {
            get;
            set;
        }
    
        public virtual decimal Price
        {
            get;
            set;
        }
    
        public virtual byte[] Picture
        {
            get;
            set;
        }
    
        public virtual bool IsActive
        {
            get;
            set;
        }

        #endregion
        #region Navigation Properties
    
        public virtual ProductGroup ProductGroup
        {
            get { return _productGroup; }
            set
            {
                if (!ReferenceEquals(_productGroup, value))
                {
                    var previousValue = _productGroup;
                    _productGroup = value;
                    FixupProductGroup(previousValue);
                }
            }
        }
        private ProductGroup _productGroup;
    
        public virtual ICollection<OrderItem> OrderItems
        {
            get
            {
                if (_orderItems == null)
                {
                    var newCollection = new FixupCollection<OrderItem>();
                    newCollection.CollectionChanged += FixupOrderItems;
                    _orderItems = newCollection;
                }
                return _orderItems;
            }
            set
            {
                if (!ReferenceEquals(_orderItems, value))
                {
                    var previousValue = _orderItems as FixupCollection<OrderItem>;
                    if (previousValue != null)
                    {
                        previousValue.CollectionChanged -= FixupOrderItems;
                    }
                    _orderItems = value;
                    var newValue = value as FixupCollection<OrderItem>;
                    if (newValue != null)
                    {
                        newValue.CollectionChanged += FixupOrderItems;
                    }
                }
            }
        }
        private ICollection<OrderItem> _orderItems;

        #endregion
        #region Association Fixup
    
        private void FixupProductGroup(ProductGroup previousValue)
        {
            if (previousValue != null && previousValue.Products.Contains(this))
            {
                previousValue.Products.Remove(this);
            }
    
            if (ProductGroup != null)
            {
                if (!ProductGroup.Products.Contains(this))
                {
                    ProductGroup.Products.Add(this);
                }
            }
        }
    
        private void FixupOrderItems(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.NewItems != null)
            {
                foreach (OrderItem item in e.NewItems)
                {
                    item.Product = this;
                }
            }
    
            if (e.OldItems != null)
            {
                foreach (OrderItem item in e.OldItems)
                {
                    if (ReferenceEquals(item.Product, this))
                    {
                        item.Product = null;
                    }
                }
            }
        }

        #endregion
    }
}
