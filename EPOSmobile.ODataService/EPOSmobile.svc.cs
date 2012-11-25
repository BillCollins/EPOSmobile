using System;
using System.Collections.Generic;
using System.Data.Services;
using System.Data.Services.Common;
using System.Linq;
using System.ServiceModel.Web;
using System.Web;
using System.Data.Objects;
using EPOSmobile.Domain.Entities;

namespace EPOSmobile.ODataService {
	public class EPOSmobile : DataService<EPOSmobileContext> {

		public static void InitializeService(DataServiceConfiguration config) {
			config.SetEntitySetAccessRule("*", EntitySetRights.AllRead);
			
			//config.SetEntitySetAccessRule("Address", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Employee", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Menu", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Order", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("OrderItem", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Product", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("ProductGroup", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Room", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Sales", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Shift", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("ShiftSchedule", EntitySetRights.AllRead);
			//config.SetEntitySetAccessRule("Table", EntitySetRights.AllRead);

			//config.SetServiceOperationAccessRule("MyServiceOperation", ServiceOperationRights.All);
		
			config.DataServiceBehavior.MaxProtocolVersion = DataServiceProtocolVersion.V2;
			config.UseVerboseErrors = true;
		}

		protected override EPOSmobileContext CreateDataSource() {
			EPOSmobileContext context = new EPOSmobileContext();
			context.ContextOptions.ProxyCreationEnabled = true;
			return context;
		}
	}
}
