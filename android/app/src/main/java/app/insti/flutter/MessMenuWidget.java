package app.insti.flutter;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.widget.RemoteViews;

import java.time.OffsetTime;
import java.util.Calendar;
import java.util.List;

import app.insti.api.RetrofitInterface;
import app.insti.api.ServiceGenerator;
import app.insti.api.model.HostelMessMenu;
import app.insti.api.model.MessMenu;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Implementation of App Widget functionality.
 */
public class MessMenuWidget extends AppWidgetProvider {

    // TODO Remove duplicate code from MessMenuFragment
    private static RemoteViews views;
    private static List<HostelMessMenu> instituteMessMenu;

    public static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                       int appWidgetId) {



        // Construct the RemoteViews object
        views = new RemoteViews(context.getPackageName(), R.layout.mess_menu_widget);

            ServiceGenerator serviceGenerator = new ServiceGenerator(context);
            RetrofitInterface retrofitInterface = serviceGenerator.getRetrofitInterface();
            retrofitInterface.getInstituteMessMenu(1).enqueue(new Callback<List<HostelMessMenu>>() {



                @Override
                public void onResponse(Call<List<HostelMessMenu>> call, Response<List<HostelMessMenu>> response) {
                    if (response.isSuccessful()) {
                        instituteMessMenu = response.body();
                        CharSequence widgetText = MessMenuWidgetWithHostelConfigureActivity.loadTitlePref(context, appWidgetId);
                        displayMenu(widgetText);


                        // Instruct the widget manager to update the widget
                        appWidgetManager.updateAppWidget(appWidgetId,
                                views);
                    }
                }

                @Override
                public void onFailure(Call<List<HostelMessMenu>> call, Throwable t) {
                    // Network error

                }
            });

    }


    private static void displayMenu(CharSequence hostel) {
        HostelMessMenu hostelMessMenu = findMessMenu(instituteMessMenu, hostel);
        if (hostelMessMenu != null)
            displayMessMenu(hostelMessMenu);
    }





    private static void displayMessMenu(HostelMessMenu hostelMessMenu) {
        MessMenu todaysMenu = hostelMessMenu.getSortedMessMenus().get(0);
        MessMenu tomsMenu = hostelMessMenu.getSortedMessMenus().get(1);
        String name = hostelMessMenu.getName();

        int day = todaysMenu.getDay();

        Calendar calendar    = Calendar.getInstance();
        int hourOfDay = calendar.get(Calendar.HOUR_OF_DAY);
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        OffsetTime offset = OffsetTime.now();

        hourOfDay = offset.getHour();


        // TODO: Consider moving to a separate Meal class
        String mealType;
        String mealTime;
        String menu;
        if (hourOfDay >= 22 || hourOfDay < 10) {
            // breakfast
            mealType = "Breakfast";
            if (hourOfDay >= 22) {
                menu = tomsMenu.getBreakfast();
                day = tomsMenu.getDay();
            }
            else {
                menu = todaysMenu.getBreakfast();
            }
            if (dayOfWeek == Calendar.SATURDAY || dayOfWeek == Calendar.SUNDAY) {
                mealTime = "8am to 10am";
            } else {
                mealTime = "7:30am to 9:30am";
            }
        } else if (hourOfDay < 14) {
            // lunch
            mealType = "Lunch";
            menu = todaysMenu.getLunch();
            mealTime = "12noon to 2pm";
        } else if (hourOfDay < 18) {
            // snacks
            mealType = "Snacks";
            menu = todaysMenu.getSnacks();
            mealTime = "4:30pm to 6:15pm";
        } else {
            // dinner
            mealType = "Dinner";
            menu = todaysMenu.getDinner();
            mealTime = "8pm to 10pm";
        }

        views.setTextViewText(R.id.day_text_view, generateDayString(day));
        views.setTextViewText(R.id.hostel_name, name);
        views.setTextViewText(R.id.meal_name_text_view, mealType);
        views.setTextViewText(R.id.meal_time_text_view, mealTime);
        views.setTextViewText(R.id.meal_text_view, menu);
    }

    private static HostelMessMenu findMessMenu(List<HostelMessMenu> hostelMessMenus, CharSequence hostel) {
        for (HostelMessMenu hostelMessMenu : hostelMessMenus) {
            if (hostelMessMenu.getShortName().equals(hostel)) {
                return hostelMessMenu;

            }
        }
        return null;
    }


    public static String generateDayString(int day) {
        switch (day) {
            case 1:
                return "Monday";
            case 2:
                return "Tuesday";
            case 3:
                return "Wednesday";
            case 4:
                return "Thursday";
            case 5:
                return "Friday";
            case 6:
                return "Saturday";
            case 7:
                return "Sunday";
            default:
                throw new IndexOutOfBoundsException("DayIndexOutOfBounds: " + day);
        }
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }

        Intent intent = new Intent(context, MainActivity.class);
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("https://www.insti.app/mess/"));
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_MUTABLE);

        views.setOnClickPendingIntent(R.id.mess_menu_widget, pendingIntent);
    }
}

