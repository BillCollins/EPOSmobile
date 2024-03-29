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
    public partial class Table
    {
        #region Primitive Properties
    
        public virtual int TableID
        {
            get;
            set;
        }
    
        public virtual string TableNumber
        {
            get;
            set;
        }

        #endregion
        #region Navigation Properties
    
        public virtual ICollection<Order> Orders
        {
            get
            {
                if (_orders == null)
                {
                    var newCollection = new FixupCollection<Order>();
                    newCollection.CollectionChanged += FixupOrders;
                    _orders = newCollection;
                }
                return _orders;
            }
            set
            {
                if (!ReferenceEquals(_orders, value))
                {
                    var previousValue = _orders as FixupCollection<Order>;
                    if (previousValue != null)
                    {
                        previousValue.CollectionChanged -= FixupOrders;
                    }
                    _orders = value;
                    var newValue = value as FixupCollection<Order>;
                    if (newValue != null)
                    {
                        newValue.CollectionChanged += FixupOrders;
                    }
                }
            }
        }
        private ICollection<Order> _orders;
    
        public virtual Room Room
        {
            get { return _room; }
            set
            {
                if (!ReferenceEquals(_room, value))
                {
                    var previousValue = _room;
                    _room = value;
                    FixupRoom(previousValue);
                }
            }
        }
        private Room _room;

        #endregion
        #region Association Fixup
    
        private void FixupRoom(Room previousValue)
        {
            if (previousValue != null && previousValue.Tables.Contains(this))
            {
                previousValue.Tables.Remove(this);
            }
    
            if (Room != null)
            {
                if (!Room.Tables.Contains(this))
                {
                    Room.Tables.Add(this);
                }
            }
        }
    
        private void FixupOrders(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.NewItems != null)
            {
                foreach (Order item in e.NewItems)
                {
                    item.Table = this;
                }
            }
    
            if (e.OldItems != null)
            {
                foreach (Order item in e.OldItems)
                {
                    if (ReferenceEquals(item.Table, this))
                    {
                        item.Table = null;
                    }
                }
            }
        }

        #endregion
    }
}
