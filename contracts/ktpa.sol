pragma solidity ^0.4.4;

contract ktpa {

  //structures for farmer
  struct farmer{
    uint farmer_uid;
    string name;
    address farmer_address;
  }

  //structures for departments
  struct departments{
    uint dept_uid;
    uint dept_type;
    string dept_name;
    address dept_address;
  }

  //structures for land
  struct land {
    uint land_uid;
    string land_location;
    address land_owner;
  }

  //structures for tree
  struct tree{
    uint tree_id;
    string tree_location;
    address tree_owner;
    uint tree_survey;
    uint tree_area;
    uint tree_planting_year;
    bool survey_dept_permission;
    bool revenue_dept_permission;
    bool forest_dept_permission;
  }

  //structures for certificate
  struct certificates{
    bytes32 hash_of_land_certificate;
    bytes32 hash_of_tree_certificate;
    bool land_owning_certificate;
    bool tree_owning_certificate;
  }

  //enum for order_status for shipment
  enum order_status {
    INITIATED,
    CONFIRMED,
    DELIVERING,
    DELIVERED
  }

  //structures for shipment
  struct shipment {
    uint g_id;
    uint[] tree_uid_it_is_carring;
    address farmer_addr;
    uint expected_delivery_date;
    string vehicle_details_type;
    string vehicle_number;
  }

  //an oracle admin that both parties trust so that it can add both farmer and dept at the starting
  address public oracle;

  //modifier for oracle that only he can call certain functions
  modifier only_oracle() {
    if(msg.sender == oracle){
      _;
    }
    else{
      throw;
    }
  }

  //modifer for the farmer to call certain functions which can only be accessed by the farmer
  modifier only_farmer(uint f_id) {
    if(farmer_id_mapping[f_id].farmer_address == msg.sender){
      _;
    }
    else{
      throw;
    }
  }

  //modifier for survey_dept that only dept can call certain functions
  modifier survey_dept_only(uint d_id) {
    if(departments_id_mapping[d_id].dept_address == msg.sender && departments_id_mapping[d_id].dept_type == 1){
      _;
    }
    else{
      throw;
    }
  }

  //modifier for land_rec_dept that only dept can call certain functions
  modifier land_rec_dept_only(uint d_id) {
    if(departments_id_mapping[d_id].dept_address == msg.sender && departments_id_mapping[d_id].dept_type == 2){
      _;
    }
    else{
      throw;
    }
  }

  //modifier for revenue_dept that only dept can call certain functions
  modifier revenue_dept_only(uint d_id) {
    if(departments_id_mapping[d_id].dept_address == msg.sender && departments_id_mapping[d_id].dept_type == 3){
      _;
    }
    else{
      throw;
    }
  }

  mapping (address => farmer) farmer_address_mapping;
  mapping (uint => farmer) farmer_id_mapping;

  mapping (address => departments) departments_address_mapping;
  mapping (uint => departments) departments_id_mapping;

  mapping (uint => land) land_id_mapping;
  mapping (uint => land) tree_id_land_mapping;
  mapping (uint => tree) tree_id_mapping;

  mapping (uint => certificates) farmer_id_certificate_mapping;

  mapping (uint => shipment) g_id_mapping;
  mapping (uint => order_status) shipment_id_order_status_mapping;

  mapping (uint => address) amount_map;

  //triggered when farmer is added
  event farmer_added(address admin_added_farmer,string person_who_was_added);
  //triggered when dept is added
  event dept_added(address admin_added_dept,string name_of_dept);
  //triggered when survey dept adds tree locatons is added
  event survey_dept_gave_loc(uint id_of_tree,string location_where_the_tree_is,address who_checked_location);
  //triggered when farmer requests for checking land ownership is added
  event farmer_requested_for_land_ownership_check(uint farmer_id,uint land_id);
  //triggered when land record department grants permission
  event land_record_department_allowed(uint land_id,uint farmer_id,address who_allowed);
  //triggered when revenue department grants permission
  event revenue_department_allowed(uint tree_id,uint farmer_id,address who_allowed);
  //triggered when shipment of the trees are initiated
  event shipment_initiated(uint g_id,uint number_of_days_to_delive,string vehicle_type,string vehicle_number);
  //triggered when the order staus is updated
  event updated_order_status(uint g_id,uint8 n);


  //constructer
  function ktpa() {
    oracle = msg.sender;
  }

  //function to add farmer to the network
  function add_farmer(uint uid,string f_name,address f_addr) only_oracle() {
    farmer_id_mapping[uid]=farmer(uid,f_name,f_addr);
    farmer_address_mapping[f_addr]=farmer(uid,f_name,f_addr);
    farmer_added(oracle, f_name);
  }

  //function to add department to the network
  function add_dept(uint uid,uint _type,string name,address d_addr) only_oracle() {
    departments_id_mapping[uid]=departments(uid,_type,name,d_addr);
    departments_address_mapping[d_addr]=departments(uid,_type,name,d_addr);
    dept_added(oracle, name);
  }

  //function to add land to the network associated with the farmer
  function add_land(uint uid,string location) only_farmer(farmer_address_mapping[msg.sender].farmer_uid) {
    land_id_mapping[uid]=land(uid,location,msg.sender);
  }

  //function to add trees to the network associated with the farmer
  function add_trees(uint uid,uint surveynumber,uint area,uint plantingyear,uint land_id) only_farmer(farmer_address_mapping[msg.sender].farmer_uid) {
    tree_id_mapping[uid]=tree(uid,"0",msg.sender,surveynumber,area,plantingyear,false,false,false);
    tree_id_land_mapping[uid]=land(land_id,"0",msg.sender);
  }

  //function to add trees location to the network by survey dept
  function add_tree_location(uint uid,string location) survey_dept_only(departments_address_mapping[msg.sender].dept_uid) {
    tree_id_mapping[uid].tree_location = location;
    tree_id_land_mapping[uid].land_location = location;
    tree_id_mapping[uid].survey_dept_permission = true;
    survey_dept_gave_loc(uid,location,msg.sender);
  }

  //function to show the details of the land where the tree is present
  function showland(uint uid) constant returns(uint,string){
    return (tree_id_land_mapping[uid].land_uid,tree_id_land_mapping[uid].land_location);
  }

  //function to request ownership check of the land by the farmer
  function req_ownership_of_land(uint land_id)  {
    farmer_id_certificate_mapping[farmer_address_mapping[msg.sender].farmer_uid] = certificates("0","0",false,false);
    farmer_requested_for_land_ownership_check(farmer_address_mapping[msg.sender].farmer_uid,land_id);
  }

  //function for the land record department to grant permission
  function give_certificate_for_land(uint f_id,uint l_id) land_rec_dept_only(departments_address_mapping[msg.sender].dept_uid) {
    farmer_id_certificate_mapping[f_id] = certificates(sha3(l_id,land_id_mapping[l_id].land_location,land_id_mapping[l_id].land_owner),"0",true,false);
    land_record_department_allowed(l_id,f_id,msg.sender);
  }

  //function for the revenue department to grant permission
  function give_certificate_for_tree(uint f_id,uint t_id) revenue_dept_only(departments_address_mapping[msg.sender].dept_uid) {
    farmer_id_certificate_mapping[f_id].hash_of_tree_certificate = sha3(t_id,tree_id_mapping[t_id].tree_survey,tree_id_mapping[t_id].tree_location,tree_id_mapping[t_id].tree_owner);
    farmer_id_certificate_mapping[f_id].tree_owning_certificate = true;
    tree_id_mapping[t_id].revenue_dept_permission = true;
    revenue_department_allowed(t_id,f_id,msg.sender);
  }

  //function to get the certificate by anone in the blockchain so that the permit certificate has not to be sent to everyone individually
  //saves time as sending documents to stakeholders and verifying them is not required,anyone can see the certificates
  function get_certificate(uint f_id) constant returns (bytes32 Land_Certificate_ID, bytes32 Tree_Certificate_ID) {
    Land_Certificate_ID = farmer_id_certificate_mapping[f_id].hash_of_land_certificate;
    Tree_Certificate_ID = farmer_id_certificate_mapping[f_id].hash_of_tree_certificate;
  }

  //function to get the ng details
  function shipment_details(uint uid,uint[] _trees,uint no_of_days,string veh_det,string veh_no) only_farmer(farmer_address_mapping[msg.sender].farmer_uid) {
    for(uint i=0;i<_trees.length;i++){
      if(tree_id_mapping[_trees[i]].survey_dept_permission != true)
        throw;
    }
    g_id_mapping[uid] = shipment(uid,_trees,msg.sender,no_of_days,veh_det,veh_no);
    shipment_id_order_status_mapping[uid] = order_status.INITIATED;
    shipment_initiated(uid,no_of_days,veh_det,veh_no);
  }

  uint recievedtime = 0;

  //function to change the shipmetn status
  function change_shipment_status(uint uid,uint8 n) {
    shipment_id_order_status_mapping[uid] = order_status(n);
    if(n==3)
      recievedtime=now;
    updated_order_status(uid,n);
  }

  //function to show shipmetn details
  function show_shipment_details(uint ship_id) constant returns (uint SHIP_ID,uint[] TREES_IN_SHIP,address FARMER,string VEH_TYPE,string VEH_NO) {
    SHIP_ID=g_id_mapping[ship_id].g_id;
    TREES_IN_SHIP=g_id_mapping[ship_id].tree_uid_it_is_carring;
    FARMER=g_id_mapping[ship_id].farmer_addr;
    VEH_TYPE=g_id_mapping[ship_id].vehicle_details_type;
    VEH_NO=g_id_mapping[ship_id].vehicle_number;
  }

  //function to calculate energy used for post-processing
  function postprocess_energy(uint kwh,uint offset_in_hours) constant returns(uint) {
    recievedtime=recievedtime+offset_in_hours*60*60;
    return ((now-recievedtime)/3600)*4*kwh;

  }

  uint[] amounts;

  //function to bid money for the product
  function bid_Money(uint amount) payable {
    amounts.push(amount);
    amount_map[amount] = msg.sender;
    this.transfer(amount);
  }

  //function to select the winning bid
  function winning_bid() only_farmer(farmer_address_mapping[msg.sender].farmer_uid) {
    for(uint j=0;j<amounts.length-1;j++){
      for(uint k=0;k<amounts.length-j-1;k++){
        if(amounts[k]<amounts[k+1]){
          uint temp = amounts[k];
          amounts[k] = amounts[k+1];
          amounts[k+1] = temp;
        }
      }
    }
    for(uint l=1;l<amounts.length-1;l++){
      amount_map[amounts[l]].transfer(amounts[l]);
    }
    msg.sender.transfer(amounts[0]);
    amounts.length = 0;
  }

  //call-back function
  function () payable {

  }

}
