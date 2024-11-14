import { LightningElement, wire, track } from 'lwc';
import getLeads from '@salesforce/apex/LeadController.getLeads';

export default class retrieveLeads extends LightningElement {
    @track leads; 
    @track columns = [
        { label: 'Name', fieldName: 'Name', sortable: true },
        { label: 'Industry', fieldName: 'Industry', sortable: true },
        {
            type: 'action',
            typeAttributes: { rowActions: this.getRowActions } 
        }
    ];
    @track sortedBy;
    @track sortedDirection = 'asc'; 
    
    @wire(getLeads)
    wiredLeads({ error, data }) {
        if (data) {
            console.log(data)
            this.leads = data;
            
        } else if (error) {
            console.error('Error fetching leads: ', error);
        }
    }
    // Define row actions
    getRowActions(row, doneCallback) {
        const actions = [
            { label: 'View', name: 'view' },
            { label: 'Delete', name: 'delete' }
        ];
        doneCallback(actions);
    }
    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view') {
            this.viewAccount(row);
        } else if (actionName === 'delete') {
            this.deleteAccount(row);
        }
    }
    
    viewAccount(row) {
        console.log('View account:', row.Id);
    }
   
    deleteAccount(row) {
        console.log('Delete account:', row.Id);
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortDirection;
        this.sortData(sortedBy, sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.accounts));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // Handle undefined values
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.accounts = parseData;
    }
}