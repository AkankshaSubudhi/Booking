<%@page import="java.util.Date"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.List"%>
<%@page import="Do.*"%>
<%@page import="Domain.*"%>
<%! int x = 10;%>
<%
    List<Reservation> resList = null;
    PassengerTicketDO ptdo = new PassengerTicketDO();
    ReservationStatusDO rsdo = new ReservationStatusDO();
    boolean showUser = false;

    int role = (Integer) session.getAttribute("role_id");
    try {
        if (role == 1) {
            resList = new ReservationDO().getAll();
            showUser = true;
        } else {
            long userId = (Long) session.getAttribute("user_id");
            resList = new ReservationDO().getAllWithUserId((int) userId);
        }
        if (resList.isEmpty()) {
            out.println("<br><br><h3><label class=\"label label-info\">No Tickets Now..! </label></h3>");
            out.close();
            return;
        }
    } catch (SQLException ex) {
        System.out.println(ex);
    } catch (Exception e) {
        out.println(e);
    }
%>

View booked tickets:
<br>
<form id="form3">
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>Select</th><th>S.No</th>
                    <%
                        if (showUser) {
                            out.println("<th>Booked By</th>");
                        } %>
                <th>PNR</th><th>Status</th><th>No of passengers</th><th>From</th><th>To</th><th>Class</th><th>Date of booking</th><th>View Ticket</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (resList != null) {
                    int i = 1;
                    StationDO sdo = new StationDO();
                    ClassDO classDO = new ClassDO();
                    UserProfileDO udo = new UserProfileDO();
                    for (Reservation res : resList) {
                        PassengerTicket pt = ptdo.get(res.pnr);
                        String dis = "";
                        String user = "";
                        try {
                            if (showUser) {
                                user = udo.get(res.userId).username;
                            }
                        } catch (Exception e) {
                            out.println(e);
                            out.println(res.userId);
                        }
                        if (res.ReservationStatus == 3) {
                            dis = "disabled";
                        }
                        out.println("<tr><td><input type=\"radio\" name=\"pnr\" value=\"" + res.pnr + "\" " + dis + " > " + "</td><td>" + (i++) + "</td>");
                        if (showUser) {
                            out.println("<td>" + user + "</td>");
                        }
                        out.println("<td>" + res.pnr + "</td><td>" + rsdo.get(res.ReservationStatus).status + "<td>" + pt.Adult + "</td><td>" + sdo.get(pt.fromStationId).name + "</td><td>" + sdo.get(pt.toStationId).name + "</td><td>" + classDO.get(res.classId).name + "</td><td>" + res.timestamp + "</td><td><a href=\"javascript:void(0)\" onClick=\"viewTic(" + pt.pnr + ") \" > <img height=\"20\" src=\"css/view.jpg \"> </a></td></tr>");
                    }
                }
            %>
        </tbody>
    </table>
</form>
<button onclick="ProcessCancel()">Cancel selected ticket</button>
