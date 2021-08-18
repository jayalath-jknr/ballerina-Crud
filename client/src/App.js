
import './App.css';

function App() {
  return (
    <div className="App">
      <h1>HOME</h1>
    <div >
    <h3>ADD EMPLOYEE</h3>
      <form id= "form1">
        <label for ="empid"> Employee ID : </label>
        <input type = "text" id="empid"></input><br/><br/>
        <label for ="lname"> First Name: </label>
        <input type = "text"id="fname"></input><br/><br/>
        <label for ="lname"> Last Name: </label>
        <input type = "text" id="lname"></input><br/><br/>
        <label for ="dob"> Date of birth : </label>
        <input type = "text"id="dob"></input><br/><br/>
        <label for ="email"> Email : </label>
        <input type = "text" id="email"></input><br/><br/>
        {/* <label for ="dep"> Departtment : </label>
        <input type = "text"id="dep"></input><br/> */}

        <button type="submit" form="form1" value="submit"> Submit </button>
      </form>
    </div>
    </div>
  );
}

export default App;
